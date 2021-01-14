#!/bin/bash

# shellcheck disable=SC2155

set -euo pipefail

DRY_RUN=${DRY_RUN:-}
DOCKER_REGISTRY=${DOCKER_REGISTRY:-quay.io}
DOCKER_ORG=${DOCKER_ORG:-app-sre}
SET_X=${SET_X:-}
[[ -n "$SET_X" ]] && set -x

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
        check_vars GIT_PREVIOUS_COMMIT GIT_COMMIT || return 1
        commit_range="$GIT_PREVIOUS_COMMIT...$GIT_COMMIT"
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
        changed="$changed $(dirname "$line")"
    done < <(git diff --name-only "$commit_range" | grep 'VERSION$')

    echo "$changed"
}

function get_authenticated_docker_command() {
    local config_dir=$(mktemp -d)
    # shellcheck disable=SC2064
    trap "rm -rf $config_dir" EXIT
    local docker_authd="docker --config $config_dir"

    check_vars QUAY_USER QUAY_TOKEN || return 1

    if [[ -z "$DRY_RUN" ]]; then
        $docker_authd login -u "$QUAY_USER" -p "$QUAY_TOKEN" "$DOCKER_REGISTRY" 1>&2 || return 1
    fi

    echo "$docker_authd"
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

    log "Changed files are: $changed"

    local docker_authd
    if [[ "$origin" == "build" ]]; then
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

    return $rc
}

# Main
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@" || exit 1
fi
