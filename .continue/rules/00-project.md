---
name: project-contract
alwaysApply: true
---

# Project contract

Read and follow `AGENTS.md` and `.ai/` before changing this repository.

- Container-first: use `make` targets, which execute in Podman.
- No host runtimes, package managers, databases, or Docker.
- One pinned language per project (`project.env`); AI tools are personal.
- Roles: `.ai/agents/`. Team workflow: `.ai/teams/workflow.md`.
- Tool-specific files only point to the canonical contract.

Run `make lint`, `make test`, and `make ci` for evidence.
