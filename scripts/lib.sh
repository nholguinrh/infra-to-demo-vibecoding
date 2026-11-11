#!/usr/bin/env bash
# Shared helpers. This file is sourced; do not execute it directly.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export ROOT

if [[ ! -f "$ROOT/project.env" ]]; then
  printf 'error: project.env not found in %s\n' "$ROOT" >&2
  exit 1
fi

# shellcheck disable=SC1091
set -a
source "$ROOT/project.env"
set +a

if [[ -f "$ROOT/.env" ]]; then
  # shellcheck disable=SC1091
  set -a
  source "$ROOT/.env"
  set +a
fi

STACK_PATH="${STACK_PATH:-./stacks/$STACK}"
STACK_DIR="$ROOT/${STACK_PATH#./}"

export COMPOSE_PROJECT_NAME STACK STACK_PATH APP_PORT CONTAINER_PORT
export DB_IMAGE DB_NAME DB_USER DB_PORT_HOST

if [[ -t 1 && -z "${NO_COLOR:-}" ]]; then
  C_RESET=$'\033[0m'; C_INFO=$'\033[36m'; C_OK=$'\033[32m'; C_WARN=$'\033[33m'; C_ERR=$'\033[31m'
else
  C_RESET=""; C_INFO=""; C_OK=""; C_WARN=""; C_ERR=""
fi

info() { printf '%s==>%s %s\n' "$C_INFO" "$C_RESET" "$*"; }
ok()   { printf '%sok%s  %s\n' "$C_OK" "$C_RESET" "$*"; }
warn() { printf '%swarn%s %s\n' "$C_WARN" "$C_RESET" "$*" >&2; }
die()  { printf '%serr%s %s\n' "$C_ERR" "$C_RESET" "$*" >&2; exit 1; }

load_stack() {
  local file="$STACK_DIR/stack.env"
  [[ -f "$file" ]] || die "Missing stack definition: $file"
  # shellcheck disable=SC1090
  set -a
  source "$file"
  set +a
}

ensure_env() {
  if [[ ! -f "$ROOT/.env" ]]; then
    cp "$ROOT/.env.example" "$ROOT/.env"
    warn "Created .env from .env.example. Change DB_ROOT_PASSWORD and ENVPASSWORD before real use."
    # shellcheck disable=SC1091
    set -a
    source "$ROOT/.env"
    set +a
  fi
}

compose() {
  local files=(-f "$ROOT/compose.yaml" -f "$STACK_DIR/compose.yaml")
  if [[ -f "$ROOT/.env" ]]; then
    (cd "$ROOT" && podman compose --env-file project.env --env-file .env "${files[@]}" "$@")
  else
    (cd "$ROOT" && podman compose --env-file project.env "${files[@]}" "$@")
  fi
}

container_for() {
  local service="${1:?service required}" name=""

  name="$(podman ps \
    --filter "label=com.docker.compose.project=$COMPOSE_PROJECT_NAME" \
    --filter "label=com.docker.compose.service=$service" \
    --format '{{.Names}}' 2>/dev/null | head -n1 || true)"

  if [[ -z "$name" ]]; then
    name="$(podman ps \
      --filter "label=io.podman.compose.project=$COMPOSE_PROJECT_NAME" \
      --filter "label=io.podman.compose.service=$service" \
      --format '{{.Names}}' 2>/dev/null | head -n1 || true)"
  fi

  if [[ -z "$name" ]]; then
    local candidate
    for candidate in "${COMPOSE_PROJECT_NAME}_${service}_1" "${COMPOSE_PROJECT_NAME}-${service}-1"; do
      if podman container exists "$candidate" 2>/dev/null; then
        name="$candidate"
        break
      fi
    done
  fi

  [[ -n "$name" ]] || die "No running container for service '$service' in project '$COMPOSE_PROJECT_NAME'. Run 'make up' first."
  printf '%s\n' "$name"
}

exec_it() {
  local tty=(-i)
  if [[ -t 0 && -t 1 ]]; then
    tty=(-it)
  fi
  podman exec "${tty[@]}" "$@"
}
