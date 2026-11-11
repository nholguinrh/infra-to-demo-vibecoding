# Stacks

Each directory is a pinned language/framework environment. A stack is small on purpose:

```
stacks/<name>/
  Containerfile      multi-stage build: dev + prod
  stack.env          language, port, shell, lint/test/fmt commands
  compose.yaml       stack-specific volumes and working directory
  README.md          language-specific instructions
  template/          hello world + tests, copied to app/ by make init
```

## Current stacks

| Stack | Language | Port |
|---|---|---|
| [`python-fastapi`](python-fastapi/) | Python 3.12 | 8000 |
| [`php-drupal`](php-drupal/) | PHP 8.3 / Drupal 11 | 80 (host 8080) |
| [`java-springboot`](java-springboot/) | Java 21 | 8080 |
| [`java-quarkus`](java-quarkus/) | Java 21 | 8080 |
| [`r-plumber`](r-plumber/) | R 4.4 | 8000 |

## Choose a stack

```bash
make init STACK=python-fastapi
```

`make init` copies `template/` into `app/` and writes `STACK`, `STACK_PATH`,
`CONTAINER_PORT`, and `APP_PORT` into `project.env`. It refuses to overwrite a non-empty `app/`
unless you pass `FORCE=1`.

## Add a stack

See [`docs/adding-a-stack.md`](../docs/adding-a-stack.md). Record an ADR. Do not switch an existing
project's language as a side effect.
