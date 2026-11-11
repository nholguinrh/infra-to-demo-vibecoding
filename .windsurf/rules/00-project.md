---
trigger: always_on
---

# Project contract

The canonical contract is `AGENTS.md`. Read it and the files under `.ai/` before editing.

- Container-first: use `make` targets; they run in Podman.
- No host installs, no Docker.
- The language/stack is pinned in `project.env`. The AI tool is not.
- Shared roles: `.ai/agents/`. Team workflow: `.ai/teams/workflow.md`.
- Tool-specific files may add syntax, never policy.

Verify with `make lint`, `make test`, and `make ci`.
