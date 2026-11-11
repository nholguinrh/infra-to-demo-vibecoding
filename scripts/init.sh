#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=lib.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

stack="${1:-}"
force="${2:-}"

[[ -n "$stack" ]] || die "Usage: make init STACK=<stack>  (or scripts/init.sh <stack> [--force])"
stack_dir="$ROOT/stacks/$stack"
[[ -f "$stack_dir/stack.env" ]] || die "Unknown stack '$stack'. Available: $(find "$ROOT/stacks" -mindepth 1 -maxdepth 1 -type d -printf '%f ' 2>/dev/null)"
[[ -d "$stack_dir/template" ]] || die "Stack '$stack' has no template/ directory."

app="$ROOT/app"
mkdir -p "$app"

non_empty="$(find "$app" -mindepth 1 ! -name '.gitkeep' ! -name '.DS_Store' -print -quit)"
if [[ -n "$non_empty" && "$force" != "--force" ]]; then
  die "app/ is not empty. Re-run with FORCE=1 (or scripts/init.sh $stack --force) to overwrite."
fi

if [[ -n "$non_empty" ]]; then
  warn "Overwriting contents of app/ with the '$stack' template."
fi

# shellcheck disable=SC1090
set -a
source "$stack_dir/stack.env"
set +a

info "Seeding app/ from stacks/$stack/template"
cp -a "$stack_dir/template/." "$app/"

update_env() {
  local key="$1" value="$2" file="$ROOT/project.env"
  if grep -q "^${key}=" "$file"; then
    sed -i "s|^${key}=.*|${key}=${value}|" "$file"
  else
    printf '%s=%s\n' "$key" "$value" >> "$file"
  fi
}

update_env STACK "$stack"
update_env STACK_PATH "./stacks/$stack"
update_env CONTAINER_PORT "${STACK_CONTAINER_PORT}"
update_env APP_PORT "${STACK_APP_PORT_DEFAULT}"

chmod +x "$ROOT"/scripts/*.sh 2>/dev/null || true

ok "Stack pinned to $stack in project.env"
printf '\nNext steps:\n'
printf '  1. cp .env.example .env   (if not present) and change the passwords\n'
printf '  2. make build\n'
printf '  3. make up\n'
printf '  4. make test\n'
printf '\nYour AI tool of choice will read AGENTS.md automatically. Language stays %s; tool stays personal.\n' "$stack"
