# CLAUDE.md — Claude Code adapter

@AGENTS.md

This file is a **thin adapter**. All project policy lives in `AGENTS.md` and `.ai/`.
If anything here appears to conflict with `AGENTS.md`, `AGENTS.md` wins.

## Claude Code specifics

- Use the shared roles in `.claude/agents/` (canonical definitions: `.ai/agents/`).
- Use the shared commands in `.claude/commands/` (`/verify`, `/db-query`).
- Run project work through `make` and `scripts/`. Do not install runtimes on the host.
- Do not add policy to this file. Change `AGENTS.md` or `.ai/` first, then adapt the tool files.
- Repository settings for permissions are in `.claude/settings.json`.

## Fast path

```bash
make doctor
make up
make test
make ci
```
