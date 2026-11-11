#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=lib.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"
load_stack

cmd="${*:-$STACK_LINT_CMD}"
[[ -n "$cmd" ]] || { warn "No lint command configured for $STACK"; exit 0; }

container="$(container_for app)"
info "Lint in $container: $cmd"
exec_it -w "${STACK_RUN_WORKDIR:-/workspace}" "$container" sh -lc "$cmd"
