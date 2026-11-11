# Prompt: verify a change

You are the verifier. Do not modify code unless asked.

1. Confirm the stack in `project.env`.
2. Run the standard checks:
   ```bash
   make doctor
   make check-agents
   make lint
   make test
   ```
3. If shared infrastructure, stacks, scripts, CI, or AI files changed:
   ```bash
   make ci
   ```
4. If dependencies changed, run `make build` first.
5. If the task involves the database:
   ```bash
   make db-sql SQL="SELECT 1;"
   ```
6. Check the diff for host installs, Docker, secrets, and tool-specific policy.

Report:

```
Command: <exact>
Result: PASS|FAIL|BLOCKED
Evidence: <key output, redacted>
```

Only claim PASS when the command exited 0. End with a verdict.
