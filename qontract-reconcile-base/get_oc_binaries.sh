#!/bin/bash
#
# This script attempts to download all the desired openshift client binaries
# from the official OpenShift mirror.
#
# The script attempts to download the desired MAJOR.MINOR versions from the
# more stable channels first. This will result in a set of OC binaries that are
# up-to-date as possible from a z-stream (PATCH) standpoint.
#
# Ex: get_oc_binaries.sh 4.5 4.6 4.7
#

set -euo pipefail

DRY_RUN=${DRY_RUN:-}
VERSIONS=${*:-}
SET_X=${SET_X:-}
[[ -n "$SET_X" ]] && set -x

OC_MIRROR="https://mirror.openshift.com/pub/openshift-v4/clients/ocp/"
CHECK_CHANNELS="stable fast candidate"

function log() {
    local to_log
    local msg

    to_log=${1}
    msg="$(date "+%Y-%m-%d %H:%M:%S")"

    [[ -n "$DRY_RUN" ]] && msg="$msg -- DRY-RUN"
    echo "$msg -- $to_log" 1>&2
}

function usage() {
    log ""
    log "Usage: $0 <versions>"
    log ""
    log "   Ex: $0 4.5 4.6 4.7"
    log ""
}

function main() {
    if [[ -z "$VERSIONS" ]]; then
        log "ERROR: No versions specified"
        usage
        exit 1
    fi
    for version in $VERSIONS; do
        for channel in $CHECK_CHANNELS; do
            log "Downloading for oc binary $channel-$version"
            if ! curl -sfLo "oc-$channel-$version.tar.gz" "$OC_MIRROR/$channel-$version/openshift-client-linux.tar.gz"; then
                log "Could not find download for oc binary $channel-$version"
                continue
            fi
            log "Extracting oc binary $channel-$version"
            tar xzf "oc-$channel-$version.tar.gz" oc
            /bin/mv oc "/usr/local/bin/oc-$version"
            /bin/rm "oc-$channel-$version.tar.gz"
            break
        done
        log ""
    done
}

# Main
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
