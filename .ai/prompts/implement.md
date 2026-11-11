# Prompt: implement a change

1. Read `AGENTS.md`, `.ai/policies/containers.md`, and the active `stacks/$STACK/README.md`.
2. Make the smallest correct change.
3. Put application code in `app/`. Change stack infrastructure only if the task is about it.
4. Keep the pinned language. Do not add a second runtime or package manager.
5. Add or update tests.
6. If dependencies changed, edit the manifest in `stacks/$STACK/template/` and run `make build`.
7. Run:
   ```bash
   make fmt   # if the stack has a formatter
   make lint
   make test
   ```
8. If shared infrastructure, stacks, scripts, CI, or AI files changed:
   ```bash
   make ci
   make check-agents
   ```
9. Report exact commands and results.

Hard stops:

- A required host install -> fix the container path instead.
- A Docker command -> use Podman.
- A schema change without a migration -> add a migration.
- A secret in the diff -> remove and rotate it.
