# Shared agents

These roles are tool-neutral. Vendor adapters (`.claude/agents/`, `.opencode/agent/`) are pointers,
not copies.

| Role | Use when | Output |
|---|---|---|
| [`architect`](architect.md) | Designing a change, stack decision, ADR, or migration | Plan + ADR + risks |
| [`implementer`](implementer.md) | Writing application code or stack code | Small diff + container evidence |
| [`verifier`](verifier.md) | Proving a change works | Exact commands + pass/fail output |
| [`reviewer`](reviewer.md) | Reviewing a diff or PR | Findings by severity |
| [`container-engineer`](container-engineer.md) | Containerfiles, compose, scripts, CI | Reproducible Podman changes |

## Rules for every role

1. Read `AGENTS.md` first.
2. Do not install runtimes, package managers, or databases on the host.
3. Use `make` targets; they execute in Podman.
4. Stay inside the pinned stack in `project.env`.
5. Never add AI-tool policy to a vendor adapter.
6. Report commands and results, not claims.

## Choosing a role in a tool

- **opencode:** the adapters under `.opencode/agent/` are available as subagents.
- **Claude Code:** the adapters under `.claude/agents/` are available as subagents.
- **Codex / Gemini / Cursor / Copilot / Aider:** ask the tool to "act as the verifier described in
  `.ai/agents/verifier.md`" or paste that file into the prompt.
