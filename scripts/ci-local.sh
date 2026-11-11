#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=lib.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"
load_stack

IMAGE="${COMPOSE_PROJECT_NAME}/${STACK}:ci"

info "1/4 Contract drift check (inside bash container)"
podman run --rm -v "$ROOT:/src:Z" -w /src docker.io/library/bash:5.2 ./scripts/check-ai-config.sh

info "2/4 Build dev image for $STACK"
podman build --target dev -t "$IMAGE" -f "$STACK_DIR/Containerfile" "$ROOT"

src="$ROOT/app"
if [[ -z "$(find "$src" -mindepth 1 ! -name '.gitkeep' -print -quit 2>/dev/null)" ]]; then
  src="$STACK_DIR/template"
  warn "app/ is empty; CI is validating the '$STACK' template instead."
fi

run_in_image() {
  podman run --rm -v "$src:/workspace:Z" -w /workspace "$IMAGE" sh -lc "$1"
}

info "3/4 Lint in $IMAGE"
run_in_image "$STACK_LINT_CMD"

if [[ -n "${STACK_FMT_CHECK_CMD:-}" ]]; then
  info "3b/4 Format check in $IMAGE"
  run_in_image "$STACK_FMT_CHECK_CMD"
fi

info "4/4 Tests in $IMAGE"
run_in_image "$STACK_TEST_CMD"

printf '\n'
ok "Container CI passed for $STACK"
