# AI tool portability policy

## Goal

Every teammate can use a different AI tool and still follow the same workflow, because the
workflow is stored in the repository, not in the tool.

## Canonical vs. adapter

| Canonical (policy) | Adapter (syntax only) |
|---|---|
| `AGENTS.md` | `CLAUDE.md`, `GEMINI.md`, `opencode.json`, `.aider.conf.yml` |
| `.ai/policies/` | `.cursor/rules/`, `.windsurf/rules/`, `.continue/rules/` |
| `.ai/agents/` | `.claude/agents/`, `.opencode/agent/` |
| `.ai/teams/` | `.github/copilot-instructions.md`, team preferences in `team.yaml` |
| `.ai/prompts/` | `.claude/commands/`, `.opencode/command/`, `.gemini/commands/` |

An adapter may add syntax, discovery paths, or tool-specific permissions. It may **not** add a
workflow requirement, change the definition of done, or duplicate policy.

## Compatibility matrix

| Tool | Reads automatically | Adapter | Shared roles |
|---|---|---|---|
| opencode | `AGENTS.md` | `opencode.json`, `.opencode/` | `.opencode/agent/` -> `.ai/agents/` |
| Claude Code | `CLAUDE.md` (`@AGENTS.md`) | `.claude/settings.json` | `.claude/agents/` -> `.ai/agents/` |
| Codex | `AGENTS.md` | `.codex/config.toml` | copy `.ai/agents/` into the prompt |
| Gemini / Antigravity | `GEMINI.md` (`@AGENTS.md`) | `.gemini/settings.json` | copy `.ai/agents/` into the prompt |
| Cursor | `.cursor/rules/*.mdc` | always-on rule | open `.ai/agents/` manually |
| GitHub Copilot | `.github/copilot-instructions.md` | pointer file | open `.ai/agents/` manually |
| Aider | `read:` list | `.aider.conf.yml` | open `.ai/agents/` manually |
| Windsurf | `.windsurf/rules/` | always-on rule | open `.ai/agents/` manually |
| Continue | `.continue/rules/` | always-on rule | open `.ai/agents/` manually |

## Adding a new tool

1. Add its entry point (for example `TOOL.md` or `.tool/rules/`).
2. Make it reference `AGENTS.md` and the relevant `.ai/` files.
3. Do **not** copy project policy into the new file.
4. Add the entry point to `scripts/check-ai-config.sh`.
5. Run `make check-agents`.
6. Add a row to `docs/ai-tools.md` and this matrix.

## Personal configuration

Never commit:

- model names or personal provider settings in shared files
- API keys
- editor keybindings
- local MCP server definitions
- machine-specific paths

Team-level preferences (for example "most of us use opencode") may be listed in
`.ai/teams/team.yaml` as advisory. They never block a teammate from using another tool.

## Drift detection

`make check-agents` verifies that:

- every adapter exists and references `AGENTS.md`
- canonical agents, teams, and policies exist
- shared role adapters point to `.ai/agents/`
- `project.env` does not pin an AI tool
- every stack declares the required contract
- no Docker invocation exists in automation
