#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=lib.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"
load_stack

cmd="${*:-$STACK_TEST_CMD}"
[[ -n "$cmd" ]] || die "No test command configured in $STACK_DIR/stack.env"

container="$(container_for app)"
info "Tests in $container: $cmd"
exec_it -w "${STACK_RUN_WORKDIR:-/workspace}" "$container" sh -lc "$cmd"
