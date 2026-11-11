#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=lib.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

info "Checking host tooling (host is allowed only git, editor, podman, AI tool)"
command -v git >/dev/null 2>&1 || die "git is required on the host."
command -v podman >/dev/null 2>&1 || die "podman is required on the host."

podman info >/dev/null 2>&1 || die "podman is installed but not working. Try 'podman info'."
ok "podman $(podman --version | awk '{print $3}')"

if podman info --format '{{.Host.Security.Rootless}}' 2>/dev/null | grep -qx true; then
  ok "podman is running rootless"
else
  warn "podman is running rootful; rootless is recommended."
fi

if podman compose version >/dev/null 2>&1; then
  ok "podman compose provider: $(podman compose version 2>&1 | grep -m1 -E 'podman-compose version|Docker Compose version' || echo available)"
elif command -v podman-compose >/dev/null 2>&1; then
  ok "podman-compose $(podman-compose --version 2>&1 | head -n1)"
else
  die "No compose provider. Install podman-compose (pipx install podman-compose) or a compose provider."
fi

[[ -f "$STACK_DIR/stack.env" ]] || die "Missing stack.env in $STACK_DIR"
[[ -f "$STACK_DIR/Containerfile" ]] || die "Missing Containerfile in $STACK_DIR"
[[ -f "$STACK_DIR/compose.yaml" ]] || die "Missing compose fragment in $STACK_DIR"
load_stack
ok "active stack: $STACK ($STACK_LANG) — $STACK_DESCRIPTION"

if [[ -f "$ROOT/.env" ]]; then
  ok ".env exists"
  if grep -q 'change-me' "$ROOT/.env"; then
    warn ".env still contains example passwords."
  fi
else
  warn ".env is missing. 'make up' will create it from .env.example."
fi

for tool in git podman make; do
  command -v "$tool" >/dev/null 2>&1 || die "Required host command missing: $tool"
done

printf '\nOptional AI tools detected on this host:\n'
for tool in opencode claude codex gemini agy cursor; do
  if command -v "$tool" >/dev/null 2>&1; then
    printf '  %s- %s (%s)\n' "$C_OK" "$tool" "$(command -v "$tool")"
  fi
done

printf '\n'
ok "doctor completed. Next: make init STACK=<stack> && make up"
