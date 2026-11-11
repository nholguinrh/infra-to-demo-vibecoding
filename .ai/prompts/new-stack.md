# Prompt: add a new language stack

Read `AGENTS.md`, `.ai/policies/languages.md`, and `docs/adding-a-stack.md` first.

Create:

```
stacks/<name>/
  Containerfile      # stages: dev and prod
  stack.env          # STACK_LANG, STACK_CONTAINER_PORT, STACK_APP_PORT_DEFAULT,
                     # STACK_SHELL, STACK_TEST_CMD, STACK_LINT_CMD,
                     # optional STACK_FMT_CMD and STACK_FMT_CHECK_CMD
  compose.yaml       # volumes/workdir fragment; no secrets
  README.md          # language-specific dev, test, dependency, prod notes
  template/          # runnable hello world + at least one test + dependency manifest
```

Requirements:

- Multi-stage `Containerfile`; `prod` runs non-root where possible.
- No Docker. Podman compose only.
- Base images pinned. Document exceptions.
- The template must pass `STACK_LINT_CMD` and `STACK_TEST_CMD` in the dev image.
- Add an ADR in `docs/adr/` recording the stack decision.
- Do not change `project.env` for an existing project unless the task explicitly changes that
  project's language.
- Run `make check-agents` and validate the new stack in a scratch copy:
  ```bash
  scripts/init.sh <name> --force
  make build
  make up
  make test
  make ci
  ```
- Update `stacks/README.md`, `README.md`, and `docs/ai-tools.md` if needed.
