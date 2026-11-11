# Adding a language stack

A stack is an environment, not an application. Keep it small and reproducible.

## 1. Create the directory

```
stacks/<name>/
  Containerfile
  stack.env
  compose.yaml
  README.md
  template/
```

## 2. `stack.env`

Required:

```bash
STACK_LANG=<python|php|java|r|...>
STACK_DESCRIPTION=Human readable name
STACK_CONTAINER_PORT=8000
STACK_APP_PORT_DEFAULT=8000
STACK_SHELL=bash
STACK_RUN_WORKDIR=/workspace
STACK_TEST_CMD="<command>"
STACK_LINT_CMD="<command>"
# optional
STACK_FMT_CMD="<command>"
STACK_FMT_CHECK_CMD="<command>"
```

Commands run **inside** the dev image with the application mounted at `STACK_RUN_WORKDIR`.

## 3. `Containerfile`

Use at least:

- `deps` — install runtime dependencies from the template manifest
- `dev` — add test/lint tooling; no application source baked in
- `prod` — copy `app/`, install only runtime dependencies, run as non-root if possible

The build context is the **repository root** because `prod` needs `app/`. COPY paths therefore start
with `stacks/<name>/template/...` or `app/...`.

Example skeleton:

```dockerfile
FROM <runtime> AS deps
WORKDIR /workspace
COPY stacks/<name>/template/<manifest> /tmp/
RUN <install dependencies>

FROM deps AS dev
CMD ["<dev command>"]

FROM deps AS build
COPY app/ /workspace/
RUN <build>

FROM <runtime-slim> AS prod
RUN groupadd --gid 1001 app && useradd --uid 1001 --gid app --create-home app
COPY --from=build /workspace/<artifact> /app/
USER app
CMD ["<run>"]
```

## 4. `compose.yaml` fragment

```yaml
services:
  app:
    volumes:
      - ./app:/workspace:Z
    working_dir: /workspace
```

If the framework serves from a different directory (Drupal), mount individual subdirectories as the
`php-drupal` stack does. Use `:Z` for SELinux hosts.

## 5. `template/`

Include:

- a runnable hello world
- a dependency manifest (requirements, `pom.xml`, `composer.json`, `DESCRIPTION`, etc.)
- at least one test
- optional formatter/linter config
- no secrets

The template must pass `STACK_LINT_CMD` and `STACK_TEST_CMD` in the dev image.

## 6. Test it in a scratch copy

Do not overwrite an existing project's `app/`. Easiest:

```bash
cp -a . /tmp/stack-test
cd /tmp/stack-test
scripts/init.sh <name> --force
make build
make up
make test
make ci
```

## 7. Register and document

- Add the stack to `README.md` and `stacks/README.md` tables.
- Add an ADR in `docs/adr/` recording the choice and trade-offs.
- Update `scripts/check-ai-config.sh` only if the stack contract itself changes.
- If the stack introduces a service, add a health check and document it.

## 8. Guardrails

- Do not change the active stack in `project.env` for an existing project.
- Do not add Docker.
- Do not require a host runtime.
- Do not add an AI tool to the stack. Stacks are tool-neutral.
- Do not ship `latest` as a production base image without a documented reason.
