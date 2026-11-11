# AI tools

The repository works with **any** AI coding tool. Workflow compatibility comes from shared,
tool-neutral files, not from a feature of a specific vendor.

## Matrix

| Tool | Entry point | Shared roles | Recommended command |
|---|---|---|---|
| opencode | `AGENTS.md` + `opencode.json` | `.opencode/agent/` -> `.ai/agents/` | `opencode` |
| Claude Code | `CLAUDE.md` (`@AGENTS.md`) | `.claude/agents/` -> `.ai/agents/` | `claude` |
| Codex | `AGENTS.md` + `.codex/config.toml` | ask for `.ai/agents/<role>.md` | `codex` |
| Gemini / Antigravity (`agy`) | `GEMINI.md` + `.gemini/settings.json` | ask for `.ai/agents/<role>.md` | `gemini` / `agy` |
| Cursor | `.cursor/rules/000-project.mdc` | open `.ai/agents/` | Cursor UI |
| GitHub Copilot | `.github/copilot-instructions.md` | open `.ai/agents/` | Copilot Chat |
| Aider | `.aider.conf.yml` | `read:` list | `aider` |
| Windsurf | `.windsurf/rules/00-project.md` | open `.ai/agents/` | Windsurf UI |
| Continue | `.continue/rules/00-project.md` | open `.ai/agents/` | Continue UI |

## What each tool must do

1. Read `AGENTS.md` before any change.
2. Use `make` targets, never host installs or Docker.
3. Keep the pinned stack in `project.env`.
4. Run container checks and report evidence.
5. Leave policy in the canonical files.

## What stays personal

- model/provider choice
- API keys (never committed)
- editor keybindings
- local MCP servers
- personal prompt shortcuts

## Adapter rules

- An adapter may add discovery paths, syntax, permissions, and tool-specific commands.
- An adapter may **not** add workflow rules, change the definition of done, or duplicate policy.
- Every adapter must reference `AGENTS.md`.
- When adding a tool, update `scripts/check-ai-config.sh` and this document.

## Commands for every tool

```bash
make doctor
make init STACK=<stack>
make up
make lint
make test
make db-sql SQL="SELECT 1;"
make ci
make check-agents
```

If a tool asks for "setup", the answer is: clone the repository, run `make doctor`, and use the
commands above. No tool-specific setup is required for the project to work.

## Claude Code permissions

`.claude/settings.json` allows `make`, `scripts/`, and `podman`, and denies Docker, host package
installs, and reading `.env`. Adjust personal preferences in your user settings, not in the repo.

## Codex notes

Codex uses `AGENTS.md` natively. `.codex/config.toml` is intentionally minimal. Put model choices in
`~/.codex/config.toml`.

## Gemini / Antigravity notes

`.gemini/settings.json` includes `AGENTS.md` as context. `GEMINI.md` imports the same contract. Use
`.gemini/commands/verify.toml` for the verification recipe.
