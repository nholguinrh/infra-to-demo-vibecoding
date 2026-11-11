# `.ai/` — canonical, tool-neutral AI assets

Everything in this directory is **vendor-neutral**. It is the source of truth that every AI tool
adapter points to.

```
.ai/
  policies/   non-negotiable rules (containers, languages, security, AI tools)
  agents/     reusable role definitions (architect, implementer, verifier, reviewer, container engineer)
  teams/      team roster, ownership, roles, and the shared workflow
  prompts/    task recipes that any tool can copy or read
```

## Rules

1. Policy changes go here or in `AGENTS.md` — never into a vendor adapter.
2. Agents are written in plain Markdown with simple YAML frontmatter. Any tool can read them.
3. Team tool preferences are advisory. The project never requires a specific AI tool.
4. When you change something here, run `make check-agents`.

## Discovery order

1. `AGENTS.md` (the contract)
2. `.ai/teams/workflow.md`
3. `.ai/policies/*`
4. `.ai/agents/<role>.md`
5. `.ai/prompts/<task>.md`
