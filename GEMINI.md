# GEMINI.md — Gemini CLI / Antigravity (`agy`) adapter

@AGENTS.md

This file is a **thin adapter**. All project policy lives in `AGENTS.md` and `.ai/`.
If anything here conflicts with `AGENTS.md`, `AGENTS.md` wins.

## Gemini-specific notes

- Project context is configured in `.gemini/settings.json` and imports `AGENTS.md`.
- Shared roles live in `.ai/agents/`; this tool has no separate role files to maintain.
- Shared commands are `make` targets. Optional Gemini commands live in `.gemini/commands/`.
- Never install language runtimes or databases on the host. Use Podman via `make`.
- Do not encode project policy here. Update the canonical files instead.

## Fast path

```bash
make doctor
make up
make test
make ci
```
