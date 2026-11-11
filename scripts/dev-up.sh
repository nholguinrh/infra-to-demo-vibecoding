#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=lib.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

ensure_env
load_stack

info "Starting $COMPOSE_PROJECT_NAME ($STACK) with Podman"
compose up -d

printf '\n'
compose ps
printf '\n'
ok "App port: http://localhost:${APP_PORT}  (container port ${CONTAINER_PORT})"
printf 'Shell:  make shell\n'
printf 'Tests:  make test\n'
printf 'DB:     make db-sql SQL="SELECT VERSION();"\n'
