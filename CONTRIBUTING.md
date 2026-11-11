# Contributing

The canonical rules are in [`AGENTS.md`](AGENTS.md). This document is the human-facing summary.

## Branch and commit

```bash
git switch -c feat/short-scope
git commit -m "feat: add order endpoint"
```

Use Conventional Commits: `feat:`, `fix:`, `docs:`, `chore:`, `test:`, `refactor:`.
Never push directly to `main`.

## Before opening a pull request

```bash
make doctor
make up
make fmt
make lint
make test
make ci
make check-agents
```

Attach the command results to the PR. "It works on my machine" is not evidence; container output is.

## Pull request rules

- One concern per PR, small diff.
- Fill `.github/pull_request_template.md`, including the container evidence section.
- At least one approval.
- `make ci` green and no secrets.
- If you changed a stack, an AI adapter, a script, or CI, say so explicitly.

## AI tool use

Any AI tool is allowed. The project does not require or forbid opencode, Claude Code, Codex,
Gemini/Antigravity, Cursor, Copilot, Aider, Windsurf, or Continue.

- Do not commit personal model choices or tool-specific machine configuration.
- Do not add a step that requires teammates to use your tool.
- If a tool needs extra syntax, add it to that tool's adapter and keep the policy in `AGENTS.md`.
- Run `make check-agents` after touching any adapter.

## Adding a language

Follow [`docs/adding-a-stack.md`](docs/adding-a-stack.md) and record an ADR. Do not change the
active stack of an existing project as a side effect of adding a new stack.
