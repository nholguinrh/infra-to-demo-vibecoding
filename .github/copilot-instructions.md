# Copilot instructions

The canonical contract for this repository is [`AGENTS.md`](../AGENTS.md). Read it first.
This file only adapts Copilot; it adds no policy.

## Non-negotiables

- Container-first: run, lint, test, and query through Podman, normally via `make`.
- No host installs, no Docker.
- The language/stack is pinned in `project.env`; the AI tool is not.
- Shared roles live in `.ai/agents/`; team workflow in `.ai/teams/workflow.md`.
- Do not copy policy into tool-specific files.

## Commands

```bash
make doctor
make up
make lint
make test
make db-sql SQL="SELECT 1;"
make ci
```

Report exact commands and results. Do not claim success without a zero exit code.
