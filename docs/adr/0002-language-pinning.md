# ADR-0002: Pin the language, never the AI tool

- Status: accepted
- Date: 2026-11-11
- Deciders: maintainers

## Context

Teams increasingly use different AI coding tools: opencode, Claude Code, Codex, Gemini/Antigravity
(`agy`), Cursor, Copilot, Aider, Windsurf, Continue. At the same time, an application needs a stable
runtime and dependency graph. Mixing the two concerns causes churn: a tool's preference leaks into
the project, or a project becomes unusable for a teammate with a different assistant.

## Decision

1. `project.env` pins exactly one language stack (`STACK=...`).
2. AI tools are personal. No shared file may require a specific tool.
3. Canonical policy lives in `AGENTS.md` and `.ai/`. Vendor files are thin adapters.
4. Changing the language is an architecture change with an ADR.
5. `make check-agents` fails if an adapter omits the canonical contract or if `project.env` pins an
   AI tool.

## Consequences

### Positive

- Teammates can switch tools without rewriting the project.
- The language runtime stays reproducible.
- New tools are cheap to support: one adapter file.
- Reviews focus on code and evidence, not on the author's tool.

### Negative / trade-offs

- Tool-specific conveniences cannot become project requirements.
- Some duplication in adapters (a pointer file per tool), kept intentionally small.
- Maintainers must run `make check-agents` when adding a tool.

### Neutral

- Team tool preferences may be recorded in `.ai/teams/team.yaml` as advisory metadata.

## Alternatives considered

1. Standardize on one AI tool — rejected: blocks teammates and ages badly.
2. Let each tool own its workflow — rejected: incompatible practices and duplicated policy.
3. Let tools choose the language — rejected: runtime drift and supply-chain surprises.

## Container and tool impact

- `project.env` is the language pin.
- `AGENTS.md`, `.ai/`, and adapters implement tool neutrality.
- Proof: `make check-agents`.
