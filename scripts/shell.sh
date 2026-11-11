#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=lib.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"
load_stack

service="${1:-app}"
container="$(container_for "$service")"

if [[ "$service" == "db" ]]; then
  shell="${DB_SHELL:-bash}"
else
  shell="${STACK_SHELL:-bash}"
fi

info "Opening $shell in $container"
exec_it "$container" "$shell"
