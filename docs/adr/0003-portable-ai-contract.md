# ADR-0003: A portable AI contract with thin adapters

- Status: accepted
- Date: 2026-11-11
- Deciders: maintainers

## Context

Each AI tool expects instructions in a different place (`AGENTS.md`, `CLAUDE.md`, `GEMINI.md`,
`.cursor/rules`, `.github/copilot-instructions.md`, etc.). Copying rules into every file guarantees
drift. Requiring one tool breaks teammates.

## Decision

- `AGENTS.md` and `.ai/` are canonical.
- Every tool entry point is a thin adapter that references `AGENTS.md`.
- Shared roles are written once in `.ai/agents/`; vendor agent files point to them.
- Shared task recipes live in `.ai/prompts/`.
- `make check-agents` enforces existence, references, language pinning, and Podman-only automation.

## Consequences

### Positive

- One place to change policy.
- Drift is detected automatically.
- Adding a tool is a small, reviewable adapter change.
- Any teammate can use any tool and get the same workflow.

### Negative / trade-offs

- Adapters must be kept listed in the drift check.
- Tool-specific features that cannot reference external files need a short pointer file.

### Neutral

- The contract is plain Markdown/YAML, readable by humans and machines.

## Alternatives considered

1. One shared mega-file copied to every tool — rejected: drift and merge conflicts.
2. A generator that renders adapters — possible later, but unnecessary for a small adapter set.
3. No adapters, only `AGENTS.md` — rejected: several tools discover their own filenames.

## Container and tool impact

- `make check-agents` is the guard.
- The contract is intentionally independent of Podman commands, but it requires Podman for all
  execution.
