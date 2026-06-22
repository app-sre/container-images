#!/usr/bin/env bash
# SRE helper: list Reloader-related workloads, show Secret/ConfigMap refs + metadata vs pod age; optional rollout restart.
set -euo pipefail

NAMESPACE="${NAMESPACE:-$(kubectl config view --minify -o jsonpath='{.contexts[0].context.namespace}' 2>/dev/null || echo default)}"

usage() {
  cat >&2 <<EOF
Usage:
  NAMESPACE=my-ns platform-secret-checker              # report only
  NAMESPACE=my-ns platform-secret-checker --dry-run --restart-all  # print actions only
  NAMESPACE=my-ns platform-secret-checker --restart-all # restart every workload with reloader annotation
  NAMESPACE=my-ns platform-secret-checker --restart deployment/foo

Environment: NAMESPACE (defaults to current kubeconfig context namespace)

Covers: Deployments, StatefulSets, DaemonSets
Checks: reloader.stakater.com/auto, secret.reloader.stakater.com/reload,
        configmap.reloader.stakater.com/reload annotations
EOF
  exit 1
}

log() { printf '%s %s\n' "$(date -Iseconds)" "$*" >&2; }

is_reloader_managed() {
  local json=$1
  echo "$json" | jq -e '
    .metadata.annotations // {} |
    (
      .["reloader.stakater.com/auto"] == "true" or
      .["secret.reloader.stakater.com/auto"] == "true" or
      .["configmap.reloader.stakater.com/auto"] == "true" or
      has("secret.reloader.stakater.com/reload") or
      has("configmap.reloader.stakater.com/reload")
    )
  ' >/dev/null 2>&1
}

collect_secret_names() {
  local json=$1
  echo "$json" | jq -r '
    def arr($x): if ($x | type) == "array" then $x else [] end;
    .spec.template.spec as $p |
    [
      (arr($p.containers)[] | select(type == "object") | arr(.env)[]? | select(type == "object" and .valueFrom.secretKeyRef?) | .valueFrom.secretKeyRef.name),
      (arr($p.initContainers)[] | select(type == "object") | arr(.env)[]? | select(type == "object" and .valueFrom.secretKeyRef?) | .valueFrom.secretKeyRef.name),
      (arr($p.containers)[] | select(type == "object") | arr(.envFrom)[]? | select(type == "object" and .secretRef?) | .secretRef.name),
      (arr($p.initContainers)[] | select(type == "object") | arr(.envFrom)[]? | select(type == "object" and .secretRef?) | .secretRef.name),
      (arr($p.volumes)[]? | select(type == "object" and .secret?) | .secret.secretName)
    ] | map(select(. != null and . != "")) | unique | .[]
  '
}

collect_configmap_names() {
  local json=$1
  echo "$json" | jq -r '
    def arr($x): if ($x | type) == "array" then $x else [] end;
    .spec.template.spec as $p |
    [
      (arr($p.containers)[] | select(type == "object") | arr(.env)[]? | select(type == "object" and .valueFrom.configMapKeyRef?) | .valueFrom.configMapKeyRef.name),
      (arr($p.initContainers)[] | select(type == "object") | arr(.env)[]? | select(type == "object" and .valueFrom.configMapKeyRef?) | .valueFrom.configMapKeyRef.name),
      (arr($p.containers)[] | select(type == "object") | arr(.envFrom)[]? | select(type == "object" and .configMapRef?) | .configMapRef.name),
      (arr($p.initContainers)[] | select(type == "object") | arr(.envFrom)[]? | select(type == "object" and .configMapRef?) | .configMapRef.name),
      (arr($p.volumes)[]? | select(type == "object" and .configMap?) | .configMap.name)
    ] | map(select(. != null and . != "")) | unique | .[]
  '
}

report_workload() {
  local kind=$1 name=$2
  local json
  json=$(kubectl get "$kind" "$name" -n "$NAMESPACE" -o json 2>/dev/null) || return 0

  if ! is_reloader_managed "$json"; then
    return 0
  fi

  printf '\n--- %s/%s ---\n' "$kind" "$name"

  local auto named_secrets named_configmaps
  auto=$(echo "$json" | jq -r '.metadata.annotations["reloader.stakater.com/auto"] // "<unset>"')
  named_secrets=$(echo "$json" | jq -r '.metadata.annotations["secret.reloader.stakater.com/reload"] // empty')
  named_configmaps=$(echo "$json" | jq -r '.metadata.annotations["configmap.reloader.stakater.com/reload"] // empty')

  printf 'reloader.stakater.com/auto: %s\n' "$auto"
  [[ -n "$named_secrets" ]] && printf 'secret.reloader.stakater.com/reload: %s\n' "$named_secrets"
  [[ -n "$named_configmaps" ]] && printf 'configmap.reloader.stakater.com/reload: %s\n' "$named_configmaps"

  local lr
  lr=$(echo "$json" | jq -r '.spec.template.metadata.annotations["reloader.stakater.com/last-reloaded-from"] // empty')
  if [[ -n "$lr" ]]; then
    echo "$lr" | jq -r '"last-reloaded-from: " + (.|tostring)' 2>/dev/null || printf 'last-reloaded-from: %s\n' "$lr"
  fi

  printf 'Referenced Secrets:\n'
  local secrets
  secrets=$(collect_secret_names "$json" | sort -u || true)
  if [[ -z "${secrets:-}" ]]; then
    printf '  (none)\n'
  else
    while read -r s; do
      [[ -z "$s" ]] && continue
      if kubectl get secret "$s" -n "$NAMESPACE" &>/dev/null; then
        local rv uid
        rv=$(kubectl get secret "$s" -n "$NAMESPACE" -o jsonpath='{.metadata.resourceVersion}')
        uid=$(kubectl get secret "$s" -n "$NAMESPACE" -o jsonpath='{.metadata.uid}')
        printf '  %s  resourceVersion=%s uid=%s\n' "$s" "$rv" "$uid"
      else
        printf '  %s  <missing>\n' "$s"
      fi
    done <<< "$secrets"
  fi

  printf 'Referenced ConfigMaps:\n'
  local configmaps
  configmaps=$(collect_configmap_names "$json" | sort -u || true)
  if [[ -z "${configmaps:-}" ]]; then
    printf '  (none)\n'
  else
    while read -r cm; do
      [[ -z "$cm" ]] && continue
      if kubectl get configmap "$cm" -n "$NAMESPACE" &>/dev/null; then
        local rv
        rv=$(kubectl get configmap "$cm" -n "$NAMESPACE" -o jsonpath='{.metadata.resourceVersion}')
        printf '  %s  resourceVersion=%s\n' "$cm" "$rv"
      else
        printf '  %s  <missing>\n' "$cm"
      fi
    done <<< "$configmaps"
  fi

  printf 'Pods:\n'
  local sel
  sel=$(echo "$json" | jq -r '.spec.selector.matchLabels | to_entries | map("\(.key)=\(.value|tostring)") | join(",")')
  if [[ -n "$sel" ]]; then
    kubectl get pods -n "$NAMESPACE" -l "$sel" -o custom-columns='NAME:.metadata.name,CREATED:.metadata.creationTimestamp,PHASE:.status.phase' 2>/dev/null | sed 's/^/  /' || true
  else
    printf '  (empty selector)\n'
  fi
}

restart_workload() {
  local kind=$1 name=$2
  local json
  json=$(kubectl get "$kind" "$name" -n "$NAMESPACE" -o json 2>/dev/null) || return 0

  if ! is_reloader_managed "$json"; then
    return 0
  fi

  if [[ "$DRY_RUN" == "true" ]]; then
    log "DRY_RUN: would rollout restart $kind/$name"
  else
    log "rollout restart $kind/$name"
    kubectl rollout restart "$kind/$name" -n "$NAMESPACE"
  fi
}

main() {
  local mode=report
  local target=""
  DRY_RUN=false

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help) usage ;;
      --dry-run) DRY_RUN=true; shift ;;
      --restart-all) mode=restart_all; shift ;;
      --restart)
        mode=restart_one
        target="${2:-}"
        if [[ -z "$target" ]]; then log "ERROR: --restart requires <kind>/<name>"; usage; fi
        shift 2
        ;;
      *) log "Unknown arg: $1"; usage ;;
    esac
  done

  if ! kubectl get ns "$NAMESPACE" &>/dev/null; then
    log "ERROR: namespace not found: $NAMESPACE"
    exit 1
  fi

  local workload_kinds=("deployment" "statefulset" "daemonset")

  case "$mode" in
    restart_all)
      for kind in "${workload_kinds[@]}"; do
        while read -r name; do
          [[ -z "$name" ]] && continue
          restart_workload "$kind" "$name"
        done < <(kubectl get "$kind" -n "$NAMESPACE" -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' 2>/dev/null)
      done
      ;;
    restart_one)
      if [[ "$target" != */* ]]; then
        log "ERROR: target must be <kind>/<name> (e.g. deployment/my-app)"
        exit 1
      fi
      local t_kind="${target%%/*}"
      local t_name="${target#*/}"
      if [[ "$DRY_RUN" == "true" ]]; then
        log "DRY_RUN: would rollout restart $t_kind/$t_name"
      else
        kubectl rollout restart "$t_kind/$t_name" -n "$NAMESPACE"
      fi
      ;;
    report)
      log "Namespace $NAMESPACE — Reloader-managed workloads"
      for kind in "${workload_kinds[@]}"; do
        while read -r name; do
          [[ -z "$name" ]] && continue
          report_workload "$kind" "$name"
        done < <(kubectl get "$kind" -n "$NAMESPACE" -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' 2>/dev/null)
      done
      printf '\nDry-run restart command: NAMESPACE=%s platform-secret-checker --dry-run --restart-all\n' "$NAMESPACE"
      ;;
  esac
}

main "$@"
