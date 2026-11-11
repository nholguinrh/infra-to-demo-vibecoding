# Architecture

## Goal

A base repository that any teammate can clone, open with any AI coding tool, and use to build an
application in the **one language pinned for that project**, with every runtime and check inside
Podman.

## Layers

```
┌─────────────────────────────────────────────────────────────────────┐
│ AI tools (personal, swappable)                                      │
│ opencode · Claude Code · Codex · Gemini/agy · Cursor · Copilot · …   │
└───────────────┬─────────────────────────────────────────────────────┘
                │ all discover
┌───────────────▼─────────────────────────────────────────────────────┐
│ Canonical contract                                                  │
│ AGENTS.md · .ai/policies · .ai/agents · .ai/teams · .ai/prompts     │
└───────────────┬─────────────────────────────────────────────────────┘
                │ thin adapters
┌───────────────▼─────────────────────────────────────────────────────┐
│ Tool entry points                                                   │
│ CLAUDE.md · GEMINI.md · opencode.json · .cursor/rules · …           │
└───────────────┬─────────────────────────────────────────────────────┘
                │ same commands for every tool
┌───────────────▼─────────────────────────────────────────────────────┐
│ Makefile + scripts/                                                 │
│ make doctor|init|up|test|lint|db-sql|ci|check-agents                │
└───────────────┬─────────────────────────────────────────────────────┘
                │
┌───────────────▼─────────────────────────────────────────────────────┐
│ Podman                                                              │
│ compose pod: app container (stack image) + MariaDB container        │
└───────────────┬─────────────────────────────────────────────────────┘
                │
┌───────────────▼─────────────────────────────────────────────────────┐
│ Pinned language stack                                               │
│ Python · PHP/Drupal · Java/Spring Boot · Java/Quarkus · R           │
└─────────────────────────────────────────────────────────────────────┘
```

## Request flow (development)

```
developer/AI tool
   │ edits app/ (or stacks/ for skeleton work)
   ├── make up ---------> podman compose up -d
   │                        ├── app container (build target dev)
   │                        └── db container (MariaDB, health check)
   ├── make test -------> podman exec <app> <STACK_TEST_CMD>
   ├── make db-sql SQL -> podman exec <db> mariadb ... -e "SQL"
   └── make ci ---------> podman build + podman run lint/format/test
```

GitHub Actions performs the same `make ci`. There is no second recipe.

## Language pinning

`project.env` is the single source:

```
STACK=python-fastapi
STACK_PATH=./stacks/python-fastapi
CONTAINER_PORT=8000
APP_PORT=8000
```

- Changing the stack is an architecture change: ADR + deliberate PR.
- AI tool choice is not recorded. `make check-agents` rejects an AI tool pin.

## Stack boundary

A stack provides only the environment:

- `Containerfile` (`dev` and `prod` targets)
- `stack.env` (commands and ports)
- `compose.yaml` (mounts and working directory)
- `template/` (hello world + tests)
- `README.md`

The application lives in `app/` and is language-specific because the project is language-specific.

## Shared infrastructure

- `compose.yaml` — app + MariaDB, network, health check, volumes.
- `scripts/` — Podman-native automation and the AI contract check.
- `.github/workflows/ci.yml` — installs Podman and runs `make ci`.
- `.ai/` — canonical agents, teams, policies, prompts.

## Why a pod/containers rather than host processes

- Reproducible across Linux/macOS/Windows (Podman machine).
- No host pollution and no "works on my machine".
- Database clients and runtimes stay inside the network.
- CI can reproduce exactly what developers run.

Note: Podman does not expose `podman pod exec`. Exec targets a container inside the pod. The
`make` wrappers resolve the correct container automatically.
