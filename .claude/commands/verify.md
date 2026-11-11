---
description: Run the container verification recipe and report evidence
argument-hint: optional scope (app, stack, ci)
---

Act as the verifier described in `.ai/agents/verifier.md` and follow `.ai/prompts/verify.md`.

Run:

```bash
make doctor
make check-agents
make lint
make test
```

If the change touches shared infrastructure, stacks, scripts, CI, or AI files, also run:

```bash
make ci
```

Report every exact command with PASS, FAIL, or BLOCKED and quote key output. Do not claim success
without a zero exit code.
