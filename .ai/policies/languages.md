# Language and stack policy

## One pinned language per project

- The active stack is `STACK=` in `project.env`. It is a project decision, recorded in an ADR.
- A project does **not** change language because an AI tool, a tutorial, or a teammate's local
  environment prefers something else.
- A Python project does not gain a PHP service "for convenience". A Java project does not add a
  Python worker without an ADR and an explicit stack/service addition.

## AI tools are not part of the language decision

- `project.env` must not contain an AI tool name. `make check-agents` rejects it.
- `stacks/` never mentions opencode, Claude, Codex, Gemini, Cursor, Copilot, etc.
- Tool choice is personal and lives in the user's home config. Team preferences are advisory in
  `.ai/teams/team.yaml`.

## Supported stacks

| Stack | Language / framework | Container base |
|---|---|---|
| `python-fastapi` | Python 3.12 / FastAPI | `python:3.12-slim` |
| `php-drupal` | PHP 8.3 / Drupal 11 | `drupal:11-apache` |
| `java-springboot` | Java 21 / Spring Boot | `maven` + `eclipse-temurin:21-jre` |
| `java-quarkus` | Java 21 / Quarkus | `maven` + `eclipse-temurin:21-jre` |
| `r-plumber` | R 4.4 / Plumber | `rocker/r-ver` |

## Dependencies

1. Edit the manifest in `stacks/<stack>/template/` (requirements, `pom.xml`, `composer.json`,
   `requirements.R`).
2. Run `make build` so the image installs it in a clean container layer.
3. Run `make lint` and `make test`.
4. Commit the manifest change with the code that needs it.

Never install a dependency with a host command. Never rely on a package that happens to exist in
the running container but is absent from the image definition — it disappears on the next build.

## Adding a language

Follow `docs/adding-a-stack.md`. At minimum:

- `stacks/<stack>/Containerfile` with `dev` and `prod` targets
- `stacks/<stack>/stack.env` with the required keys
- `stacks/<stack>/compose.yaml` fragment (volumes/workdir)
- `stacks/<stack>/template/` hello-world code and tests
- `stacks/<stack>/README.md`
- an ADR in `docs/adr/`

Do not switch the active stack of an existing project as a side effect of adding a new stack.

## Changing the language of a project

That is an architecture change. Write an ADR explaining migration cost, data migration, and
rollback. Then change `project.env` deliberately in its own PR. Never do it silently in a feature
branch.
