#!/bin/bash

# shellcheck disable=SC2155

set -euo pipefail

DRY_RUN=${DRY_RUN:-}
DOCKER_REGISTRY=${DOCKER_REGISTRY:-quay.io}
DOCKER_ORG=${DOCKER_ORG:-app-sre}
SET_X=${SET_X:-}
[[ -n "$SET_X" ]] && set -x

# This could be defined inside get_authenticated_docker_command
# but some bash interpreters were executing this on function exit
DOCKER_CONFIG_DIR=$(mktemp -d)
trap 'rm -rf $DOCKER_CONFIG_DIR' EXIT

function log() {
    local to_log=${1}
    local msg="$(date "+%Y-%m-%d %H:%M:%S")"
    [[ -n "$DRY_RUN" ]] && msg="$msg -- DRY-RUN"
    echo "$msg -- $to_log" 1>&2
}

function check_vars() {
    rc=0
    for var in "$@"; do
        if [[ -z ${!var:-} ]]; then
            log "$var not set"
            rc=1
        fi
    done

    return $rc
}

function get_commit_range() {
    local origin=${1}

    local commit_range=""
    case $origin in
    pr)
        commit_range="$(git merge-base HEAD remotes/origin/master)...$(git rev-parse HEAD)"
        ;;
    build)
        # APPSRE-4551, load the commit of the last successful build from Git
        # as $GIT_PREVIOUS_COMMIT isn't guaranteed to have a value after Jenkins cleanup
        PREVIOUS_BUILD_SHA="$(cat ./PREVIOUS_BUILD_SHA)"
        check_vars PREVIOUS_BUILD_SHA GIT_COMMIT || return 1
        commit_range="$PREVIOUS_BUILD_SHA...$GIT_COMMIT"
        ;;
    *)
        log "Unknown origin $origin. It should be either 'pr' or 'build'"
        return 1
        ;;
    esac

    echo "$commit_range"
}

function get_changed_dockerfiles() {
    local commit_range=${1}
    local changed=""

    while read -r line; do
        [[ -s "$line" ]] || continue
        changed="$changed $(dirname "$line")"
    done < <(git diff --name-only "$commit_range" | grep 'VERSION$')

    echo "$changed"
}

function get_authenticated_docker_command() {
    local docker_authd="docker --config $DOCKER_CONFIG_DIR"

    check_vars QUAY_USER QUAY_TOKEN || return 1

    if [[ -z "$DRY_RUN" ]]; then
        $docker_authd login -u "$QUAY_USER" -p "$QUAY_TOKEN" "$DOCKER_REGISTRY" 1>&2 || return 1
    fi

    echo "$docker_authd"
}

function update_previous_build_sha() {
    echo "$GIT_COMMIT" > ./PREVIOUS_BUILD_SHA
    git add .
    git commit -m "Update previous successful build"

    IFS="/"
    read -ra branch <<< "$GIT_BRANCH"
    git push -u "${branch[0]}" "${branch[1]}"

    log "Updated the previous successful build in Git to $GIT_COMMIT"
}

function main() {
    local origin=${1:-}

    if [[ -z "$origin" ]]; then
        echo "Usage: $0 origin"
        return 1
    fi

    local commit_range
    commit_range=$(get_commit_range "$origin") || return 1

    log "Commit range is: $commit_range"

    local changed=$(get_changed_dockerfiles "$commit_range")
    if [[ -z "$changed" ]]; then
        log "No VERSION files changed. Exiting"
        [[ "$origin" == "pr" ]] && return 1 || return 0
    fi

    log "Changed directories are: $changed"

    local docker_authd
    if [[ "$origin" == "build" ]]; then
        log "Login in $DOCKER_REGISTRY"
        docker_authd=$(get_authenticated_docker_command) || return 1
    fi

    local rc=0
    for directory in $changed; do
        local version=$(head -1 "$directory/VERSION")
        if [[ -z "$version" ]]; then
            log "Empty VERSION file in $directory"
            rc=1
            continue
        fi

        local image_base="$DOCKER_REGISTRY/$DOCKER_ORG/$directory"
        local image="$image_base:$version"

        log "Building docker image $image"
        if [[ -z "$DRY_RUN" ]]; then
            cd "$directory"
            docker build -t "$image" .
            cd ..
        fi

        if [[ "$origin" == "build" ]]; then
            log "Pushing image $image"
            [[ -z "$DRY_RUN" ]] && $docker_authd push "$image"

            local latest_image="$image_base:latest"
            log "Tagging $image as $latest_image"
            [[ -z "$DRY_RUN" ]] && docker tag "$image" "$latest_image"

            log "Pushing image $latest_image"
            [[ -z "$DRY_RUN" ]] && $docker_authd push "$latest_image"
        fi
    done

    [[ -z "$DRY_RUN" ]] && [[ "$origin" == "build" ]] && update_previous_build_sha

    return $rc
}

# Main
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
