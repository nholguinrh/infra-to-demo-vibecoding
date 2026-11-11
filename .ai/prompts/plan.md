# Prompt: plan a change

Use this recipe with any AI tool. Paste it or point the tool at this file.

1. Read `AGENTS.md`, `.ai/policies/languages.md`, and the active `stacks/$STACK/README.md`.
2. State the smallest change that satisfies the request.
3. Confirm the change belongs to the pinned stack; if not, stop and propose an ADR instead.
4. Classify the scope:
   - application only (`app/`)
   - stack/infrastructure (`stacks/`, `compose.yaml`, `scripts/`, `.github/`, `.ai/`)
5. List the files to touch and the files intentionally out of scope.
6. List the container commands that will prove the change.
7. List risks, rollback, and whether an ADR is required.

Output:

```
Decision:
Scope:
Out of scope:
Files:
Container proof:
Risks:
ADR needed: yes/no
```

Do not edit files in this phase unless asked.
