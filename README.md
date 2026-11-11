# Vibe Infra

A clone-and-go skeleton for **AI-assisted application development where every runtime, test, query, and CI job runs in a Podman container**.

The repository is intentionally **tool-neutral**. A teammate can use opencode, Claude Code, Codex, Gemini/Antigravity (`agy`), Cursor, Copilot, Aider, Windsurf, or Continue. The workflow, rules, agents, and team contract are the same for everyone because they live in plain files under [`AGENTS.md`](AGENTS.md) and [`.ai/`](.ai/).

The **language/stack is pinned per project**. The **AI tool is not**. A Python project stays Python even if one developer uses Claude Code and another uses Codex.

## The four non-negotiables

1. **Container-first.** The host is only for `git`, an editor, `podman`, and the AI tool. Do not install Python, PHP, Java, R, Maven, Composer, or databases on the host.
2. **Containers for containers.** Run, lint, test, query the database, and execute CI through Podman. `make ci` is the same command locally and in GitHub Actions.
3. **One contract.** `AGENTS.md` is canonical. `CLAUDE.md`, `GEMINI.md`, `.cursor/rules`, Copilot, Aider, etc. are thin adapters that must reference the contract.
4. **Language pinned, tool free.** `project.env` pins the stack. Tool-specific files never encode project policy and never become a requirement for teammates.

## Quickstart

```bash
git clone https://github.com/nholguinrh/infra-to-demo-vibecoding.git
cd infra-to-demo-vibecoding

make doctor
make init STACK=python-fastapi      # copies a hello-world template into ./app
cp .env.example .env                # then change the passwords
make up
make test
make shell                          # shell inside the app container
make db-sql SQL="SELECT VERSION();"
make ci                             # what GitHub Actions runs, via Podman
```

Open <http://localhost:8000> (Python/FastAPI default). Use `make down` to stop.

> On first `make up`, `.env` is created from `.env.example` if missing. Change the passwords before doing anything real.

## Pick a language, not a tool

| Stack | `make init STACK=...` | Runtime in the container | Default port |
|---|---|---|---|
| Python + FastAPI | `python-fastapi` | Python 3.12 | 8000 |
| PHP + Drupal | `php-drupal` | Drupal 11 / PHP 8.3 / Apache | 8080 -> 80 |
| Java + Spring Boot | `java-springboot` | Java 21 / Maven | 8080 |
| Java + Quarkus | `java-quarkus` | Java 21 / Maven | 8080 |
| R + Plumber | `r-plumber` | R 4.4 / Plumber | 8000 |

Add a language by following [`docs/adding-a-stack.md`](docs/adding-a-stack.md). The stack contract is small: a `Containerfile`, a `stack.env`, a compose fragment, and a `template/`.

## Use any AI tool

| Tool | Entry point | How it gets the shared contract |
|---|---|---|
| opencode | `AGENTS.md`, `opencode.json` | `instructions` + `.opencode/agent/*` |
| Claude Code | `CLAUDE.md` | `@AGENTS.md` import + `.claude/agents/*` |
| Codex | `AGENTS.md` | native project instructions + `.codex/config.toml` |
| Gemini / Antigravity (`agy`) | `GEMINI.md` | `@AGENTS.md` import + `.gemini/settings.json` |
| Cursor | `.cursor/rules/000-project.mdc` | always-on rule pointing to `AGENTS.md` |
| GitHub Copilot | `.github/copilot-instructions.md` | pointer to `AGENTS.md` |
| Aider | `.aider.conf.yml` | `read:` list |
| Windsurf | `.windsurf/rules/00-project.md` | always-on rule |
| Continue | `.continue/rules/00-project.md` | always-on rule |

The shared agents are in [`.ai/agents/`](.ai/agents/), the team contract is in [`.ai/teams/`](.ai/teams/), and tool-specific adapters are intentionally tiny. See [`docs/ai-tools.md`](docs/ai-tools.md).

## How the container flow works

```
host: git + editor + AI tool + podman
        │
        ├── make up            -> podman compose -> app container + MariaDB container
        ├── make shell         -> podman exec -it <app> bash
        ├── make test          -> podman exec <app> <stack test command>
        ├── make db-sql SQL=…  -> podman exec <db> mariadb -u… -p… -e "…"
        └── make ci            -> podman build/run (same steps as GitHub Actions)
```

Direct equivalents if you prefer Podman commands over `make`:

```bash
# Inspect the containers that compose created
podman ps --filter label=com.docker.compose.project=vibe

# Open a shell in the app container
podman exec -it "$(podman ps -q --filter label=com.docker.compose.service=app)" bash

# Query the database from inside the DB container
podman exec -it "$(podman ps -q --filter label=com.docker.compose.service=db)" \
  mariadb -u"$DB_USER" -p"$ENVPASSWORD" "$DB_NAME" -e "SELECT VERSION();"
```

> Podman has no `podman pod exec`; exec targets a **container**. The Makefile resolves the right container inside the compose pod, so you never need to know its generated name.

## Repository map

```
AGENTS.md                  canonical, tool-neutral agent contract
CLAUDE.md / GEMINI.md      thin tool adapters (import AGENTS.md)
opencode.json              opencode project config
.ai/                       agents, teams, policies, prompts (canonical)
  agents/                  architect, implementer, verifier, reviewer, container-engineer
  teams/                   team.yaml, roles, tool-neutral workflow
  policies/                containers, languages, security, AI tools
app/                       YOUR application code (created by make init)
compose.yaml               base app + MariaDB services
stacks/<language>/         Containerfile + stack.env + compose fragment + template
scripts/                   all Podman-native automation
docs/                      architecture, AI tool matrix, adding a stack, ADRs
.github/                   CI (calls make ci), Copilot instructions, CODEOWNERS
project.env                committed project config: pinned stack, ports
.env                       local secrets, gitignored
```

## Why this stays compatible across tools

- **Canonical vs. adapter.** Policy lives only in `AGENTS.md`, `.ai/policies/`, `.ai/agents/`, and `.ai/teams/`. Adapter files may only add tool syntax.
- **Drift guard.** `make check-agents` fails if an adapter does not reference `AGENTS.md`, if a canonical agent/team file is missing, or if `project.env` tries to pin an AI tool.
- **Command parity.** Every task is a `make` target (or a script it calls). Agents of any vendor discover the same commands.
- **CI parity.** `.github/workflows/ci.yml` installs Podman and runs `make ci`. There is no Docker-in-Docker and no second CI recipe.

## Daily commands

```bash
make help
make up | down | restart | logs | ps
make build
make shell SERVICE=app|db
make test | lint | fmt
make db                                  # interactive MariaDB client inside the DB container
make db-sql SQL="SELECT 1;"
make ci                                  # contract + build + lint + test, all in Podman
make check-agents
make scan                                # gitleaks in Podman
make clean                               # down + delete volumes
```

## Documentation

- [`docs/architecture.md`](docs/architecture.md) — component and flow diagrams
- [`docs/containers.md`](docs/containers.md) — Podman rules, database access, debugging
- [`docs/ai-tools.md`](docs/ai-tools.md) — per-tool setup and portability matrix
- [`docs/adding-a-stack.md`](docs/adding-a-stack.md) — add Node, Go, .NET, Laravel, etc.
- [`docs/troubleshooting.md`](docs/troubleshooting.md) — common Podman/compose issues
- [`docs/adr/`](docs/adr/) — architecture decision records
- [`CONTRIBUTING.md`](CONTRIBUTING.md) — branch, PR, and review workflow
- [`SECURITY.md`](SECURITY.md) — secrets and reporting

## License

MIT. See [`LICENSE`](LICENSE).
