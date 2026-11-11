# AGENTS.md — Canonical agent contract

<!-- CONTRACT:AI-PORTABLE:v1 -->
<!-- This file is the single source of truth for every AI coding tool in this repo. -->

This repository is a **container-first, AI-tool-neutral** application skeleton. Every tool
(opencode, Claude Code, Codex, Gemini/Antigravity, Cursor, Copilot, Aider, Windsurf, Continue)
must follow this file. Tool-specific files are adapters; they may add syntax, never policy.
If an adapter disagrees with this file, **this file wins**.

## 1. Prime directive

Build, run, test, debug, and query applications **inside Podman containers**. The host is only
for `git`, an editor, `podman`, and the AI tool.

If a task seems to require installing a runtime, database, package manager, or test runner on the
host, stop. Fix the container path instead.

## 2. Non-negotiables

1. **Container-first.** Use `make` targets and scripts under `scripts/`. They call Podman.
2. **No Docker.** Do not add or run `docker`, `docker compose`, Docker-in-Docker, or cloud-only
   test recipes. The container engine is Podman.
3. **Language is pinned; AI tool is not.** `project.env` selects one stack. Never change the stack
   to make a local tool happy. Never add a requirement that teammates use a specific AI tool.
4. **One contract.** Policy belongs in `AGENTS.md` and `.ai/`. Adapters under `.claude/`,
   `.opencode/`, `.gemini/`, `.cursor/`, etc. only point back here.
5. **CI parity.** Any check added to GitHub Actions must also run through `make ci` locally.
6. **Secrets stay out of git.** Only `.env` (gitignored) holds local passwords. `.env.example`
   documents names with fake values.
7. **Evidence, not claims.** A change is done only after the relevant container commands pass and
   their output is reported.

## 3. Read order for an agent

1. `AGENTS.md` (this file)
2. `.ai/teams/workflow.md`
3. `.ai/policies/containers.md`, `.ai/policies/languages.md`, `.ai/policies/security.md`
4. `stacks/$STACK/README.md` (the active stack comes from `project.env`)
5. `.ai/agents/<role>.md` for the role you are acting as
6. `.ai/prompts/` for the task recipe (plan, implement, verify, review, new stack)

## 4. Standard commands

All commands run from the repository root.

| Goal | Command |
|---|---|
| Validate the workstation | `make doctor` |
| Select a stack and seed `app/` | `make init STACK=<stack>` |
| Start app + database | `make up` |
| Stop | `make down` |
| Rebuild containers | `make build` |
| Logs | `make logs` / `make logs SERVICE=app` |
| Shell inside a container | `make shell` / `make shell SERVICE=db` |
| Lint | `make lint` |
| Format | `make fmt` |
| Tests | `make test` |
| Interactive SQL | `make db` |
| One SQL statement | `make db-sql SQL="SELECT 1;"` |
| Full container CI | `make ci` |
| Contract drift check | `make check-agents` |
| Secret scan | `make scan` |
| Delete volumes | `make clean` |

Never run `pip`, `npm`, `composer`, `mvn`, `Rscript`, `pytest`, `mysql`, or equivalent on the
host. Run them inside the container, normally through these targets.

## 5. How to change the application

1. **Plan.** State the smallest change and the container commands that will prove it.
2. **Change code in `app/` only** (unless the task is explicitly about the skeleton itself).
3. **Dependencies.** Update the active stack's manifest in `stacks/$STACK/template/`, rebuild with
   `make build`, then run `make test` and `make lint`.
4. **Database schema.** Add a migration in the application. Use `make db-sql` only for inspection
   or debugging; never hand-edit production schema.
5. **Verify.** Run `make lint`, `make test`, and `make ci` when the change touches shared infra.
6. **Report.** Include the exact commands and pass/fail results.

## 6. Language and stack policy

- The active stack is `STACK=` in `project.env`. Treat it as a project decision recorded by an ADR.
- Do not introduce a second runtime into a project. A Python project does not gain a PHP service
  because a tool finds it convenient.
- Adding a new language/stack is a skeleton change: follow `docs/adding-a-stack.md`, add the
  stack under `stacks/`, and record an ADR. Never silently switch the active stack.
- Service additions (Redis, a worker, a second DB) belong in `compose.yaml` plus the stack's
  compose fragment, with health checks and no host dependencies.

## 7. AI tool portability policy

- **Canonical content:** `AGENTS.md`, `.ai/policies/`, `.ai/agents/`, `.ai/teams/`, `.ai/prompts/`.
- **Adapters:** `CLAUDE.md`, `GEMINI.md`, `opencode.json`, `.claude/`, `.opencode/`, `.codex/`,
  `.gemini/`, `.cursor/`, `.windsurf/`, `.continue/`, `.aider.conf.yml`,
  `.github/copilot-instructions.md`.
- Every adapter must reference `AGENTS.md` (enforced by `make check-agents`).
- Do not copy policy into an adapter. Do not add tool-specific setup steps to the README as if
  they were required for the project.
- Personal preferences (model choice, editor keybindings, local MCP servers) stay in the user's
  home config and out of this repository.
- Team-level tool preferences are advisory only. They live in `.ai/teams/team.yaml` and never
  block another teammate from using a different tool.

## 8. Team workflow

- Branch: `feat/<scope>`, `fix/<scope>`, `docs/<scope>`, `chore/<scope>`.
- Commits: Conventional Commits (`feat:`, `fix:`, `docs:`, `chore:`, `test:`, `refactor:`).
- Pull request: small, one concern, template filled, container evidence attached.
- Review: at least one approval, `make ci` green, no secrets, contract drift check green.
- Ownership: see `.github/CODEOWNERS` and `.ai/teams/team.yaml`.
- Do not push directly to `main`.

## 9. Security rules

- Never commit `.env`, credentials, tokens, private keys, or production data.
- Do not bake secrets into images or compose files. Read them from the environment.
- Production targets run as a non-root user where the base image allows it.
- Prefer pinned base image versions. Do not use `latest` for new production images.
- Run `make scan` before publishing a repository or a release.

## 10. Definition of done

A task is done only when all of these are true:

- [ ] The change is small and scoped to the request.
- [ ] No host runtime/package/database was installed.
- [ ] `make lint` passes in the container.
- [ ] `make test` passes in the container.
- [ ] `make ci` passes when shared infrastructure, stacks, scripts, or CI changed.
- [ ] `make check-agents` passes when any AI adapter or canonical agent/team file changed.
- [ ] Documentation is updated if commands, ports, stacks, or workflow changed.
- [ ] No secret, generated artifact, or local environment file is staged.
- [ ] The final report includes commands and results.

## 11. When in doubt

Ask one precise question, or choose the container-native path and explain the trade-off. Do not
guess your way into host installs, Docker, or tool-specific workflows.
