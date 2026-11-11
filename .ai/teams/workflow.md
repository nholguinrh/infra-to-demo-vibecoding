# Team workflow (tool-neutral)

This workflow is identical for every AI tool. If a tool cannot follow it, the tool adapts; the
workflow does not change.

## 1. Start from a clean, current clone

```bash
git switch main
git pull --ff-only
git switch -c feat/<scope>
make doctor
```

## 2. Plan before editing

Use `.ai/prompts/plan.md` or the architect role. State:

- the smallest change
- files to touch
- stack impact
- container commands that will prove it

## 3. Implement in small steps

Use `.ai/prompts/implement.md` or the implementer role.

- Application code goes in `app/`.
- Dependencies go in `stacks/$STACK/template/` and require `make build`.
- Infrastructure changes go in `compose.yaml`, `stacks/$STACK/`, `scripts/`, `.github/`, `.ai/`.

## 4. Verify with containers

Use `.ai/prompts/verify.md` or the verifier role.

Minimum:

```bash
make lint
make test
```

Shared infrastructure, stacks, scripts, CI, or AI contract changes:

```bash
make ci
make check-agents
```

Database work:

```bash
make db-sql SQL="SELECT 1;"
```

## 5. Review

Use `.ai/prompts/review.md` or the reviewer role. Reviewers check the contract, container rules,
security, tests, and evidence. One approval is required.

## 6. Pull request

- Fill `.github/pull_request_template.md`.
- Attach exact commands and results.
- Keep one concern per PR.
- Do not push directly to `main`.

## Branch and commit conventions

- Branches: `feat/<scope>`, `fix/<scope>`, `docs/<scope>`, `chore/<scope>`, `test/<scope>`.
- Commits: Conventional Commits.
- Rebase or merge `main` intentionally; do not rewrite shared history.

## Cross-tool handoff

When passing work to a teammate with a different tool:

1. Point them to `AGENTS.md` and the relevant `.ai/prompts/` recipe.
2. Include the exact container commands and results.
3. Do not mention personal model settings, local MCP servers, or editor configuration.
4. Do not add tool-specific steps to the repository to make handoff easier; improve the canonical
   prompt or script instead.

## Definition of done

The checklist in `AGENTS.md` section 10 is authoritative. CI must be green and evidence must be
attached.
