# Developer

## Owns

- Application code in `app/` for the pinned stack.
- Tests for the behavior they add or change.
- Dependency manifests in `stacks/$STACK/template/`.
- Container evidence for their PR.

## Duties

- Read `AGENTS.md` and the active `stacks/$STACK/README.md`.
- Use `make` targets and Podman; never install runtimes on the host.
- Keep the pinned language. Ask for an ADR before adding a second runtime or service.
- Write migrations for schema changes; use `make db-sql` only for inspection.
- Run `make lint` and `make test`; run `make ci` for infrastructure changes.
- Write a small PR with exact commands and results.

## Any AI tool

Use whichever tool you prefer. Do not commit model choices, personal MCP servers, or tool-specific
workflow requirements. If your tool cannot read `AGENTS.md` automatically, point it there first.
