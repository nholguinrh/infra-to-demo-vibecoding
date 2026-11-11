#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

pass=0
fail=0

okf() { pass=$((pass + 1)); printf '  ok   %s\n' "$1"; }
bad() { fail=$((fail + 1)); printf '  FAIL %s\n' "$1"; }

require_file() {
  if [[ -f "$ROOT/$1" ]]; then okf "exists: $1"; else bad "missing: $1"; fi
}

requires_text() {
  local file="$1" text="$2" label="${3:-$2}"
  if [[ ! -f "$ROOT/$file" ]]; then
    bad "missing: $file"
  elif grep -qF -- "$text" "$ROOT/$file"; then
    okf "$file -> $label"
  else
    bad "$file does not reference $label"
  fi
}

printf 'AI contract drift check\n\n'

printf 'Canonical files\n'
for f in \
  AGENTS.md \
  .ai/teams/workflow.md \
  .ai/teams/team.yaml \
  .ai/policies/containers.md \
  .ai/policies/languages.md \
  .ai/policies/security.md \
  .ai/policies/ai-tools.md \
  .ai/agents/architect.md \
  .ai/agents/implementer.md \
  .ai/agents/verifier.md \
  .ai/agents/reviewer.md \
  .ai/agents/container-engineer.md; do
  require_file "$f"
done

if grep -qF 'CONTRACT:AI-PORTABLE' "$ROOT/AGENTS.md"; then
  okf "AGENTS.md has the portability marker"
else
  bad "AGENTS.md is missing the CONTRACT:AI-PORTABLE marker"
fi

printf '\nTool adapters (must all reference AGENTS.md)\n'
for f in \
  CLAUDE.md \
  GEMINI.md \
  opencode.json \
  .aider.conf.yml \
  .codex/config.toml \
  .gemini/settings.json \
  .cursor/rules/000-project.mdc \
  .windsurf/rules/00-project.md \
  .continue/rules/00-project.md \
  .github/copilot-instructions.md; do
  requires_text "$f" "AGENTS.md"
done

requires_text CLAUDE.md "@AGENTS.md" "the @AGENTS.md import"
requires_text GEMINI.md "@AGENTS.md" "the @AGENTS.md import"

printf '\nShared agent adapters point at canonical roles\n'
if compgen -G "$ROOT/.claude/agents/*.md" >/dev/null; then
  for f in "$ROOT"/.claude/agents/*.md; do
    if grep -qF '.ai/agents/' "$f"; then okf ".claude/agents/$(basename "$f") -> canonical"; else bad ".claude/agents/$(basename "$f") does not point to .ai/agents/"; fi
  done
else
  bad "no .claude/agents/*.md adapters"
fi

if compgen -G "$ROOT/.opencode/agent/*.md" >/dev/null; then
  for f in "$ROOT"/.opencode/agent/*.md; do
    if grep -qF '.ai/agents/' "$f"; then okf ".opencode/agent/$(basename "$f") -> canonical"; else bad ".opencode/agent/$(basename "$f") does not point to .ai/agents/"; fi
  done
else
  bad "no .opencode/agent/*.md adapters"
fi

printf '\nLanguage pinning and tool neutrality\n'
STACK="$(grep -E '^STACK=' project.env 2>/dev/null | head -n1 | cut -d= -f2- || true)"
if [[ -n "$STACK" ]]; then okf "project.env pins STACK=$STACK"; else bad "project.env has no STACK="; fi

if grep -Eiq '^(AI_TOOL|AGENT_TOOL|CLAUDE|CODEX|OPENCODE|GEMINI|CURSOR)=' project.env; then
  bad "project.env pins an AI tool; language may be pinned, tools may not"
else
  okf "project.env does not pin an AI tool"
fi

if grep -qF '.env' .gitignore; then okf ".env is gitignored"; else bad ".env is not in .gitignore"; fi

if grep -qF 'ai_tool_pinned: false' .ai/teams/team.yaml; then
  okf "team.yaml declares ai_tool_pinned: false"
else
  bad "team.yaml must declare ai_tool_pinned: false"
fi

printf '\nActive stack contract\n'
if [[ -n "$STACK" && -f "$ROOT/stacks/$STACK/stack.env" ]]; then
  for f in stacks/$STACK/stack.env stacks/$STACK/Containerfile stacks/$STACK/compose.yaml stacks/$STACK/README.md; do
    require_file "$f"
  done
  [[ -d "$ROOT/stacks/$STACK/template" ]] && okf "exists: stacks/$STACK/template/" || bad "missing: stacks/$STACK/template/"
else
  bad "active stack '$STACK' is missing or incomplete"
fi

printf '\nEvery stack declares the required contract\n'
for d in "$ROOT"/stacks/*/; do
  name="$(basename "$d")"
  [[ -d "$d" ]] || continue
  for f in stack.env Containerfile compose.yaml README.md template; do
    if [[ -e "$d/$f" ]]; then okf "stacks/$name/$f"; else bad "stacks/$name/$f missing"; fi
  done
  if [[ -f "$d/stack.env" ]]; then
    for key in STACK_LANG STACK_CONTAINER_PORT STACK_SHELL STACK_TEST_CMD STACK_LINT_CMD; do
      if grep -q "^${key}=" "$d/stack.env"; then okf "stacks/$name/stack.env defines $key"; else bad "stacks/$name/stack.env missing $key"; fi
    done
  fi
done

printf '\nPodman-only automation\n'
if grep -RInE '\bdocker[[:space:]]+(run|build|compose|exec)\b' "$ROOT/scripts" "$ROOT/Makefile" "$ROOT/compose.yaml" 2>/dev/null | grep -v 'No Docker'; then
  bad "docker invocation found in automation (Podman only)"
else
  okf "no docker invocations in scripts, Makefile, or compose"
fi

if grep -qE '^ci:' "$ROOT/Makefile" && grep -qE '^check-agents:' "$ROOT/Makefile"; then
  okf "make ci and make check-agents targets exist"
else
  bad "Makefile is missing ci or check-agents"
fi

printf '\n'
if [[ "$fail" -gt 0 ]]; then
  printf 'FAILED: %d passed, %d failed\n' "$pass" "$fail"
  exit 1
fi
printf 'PASSED: %d checks\n' "$pass"
