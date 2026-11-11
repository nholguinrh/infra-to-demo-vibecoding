# Codex adapter

Codex reads [`AGENTS.md`](../AGENTS.md) automatically. That file is the full contract; this directory
only holds safe project defaults.

## Shared roles and prompts

Codex does not need vendor copies of the roles. Ask it to act as a role:

> Act as the verifier in `.ai/agents/verifier.md` and follow `.ai/prompts/verify.md`.

or

> Act as the container engineer in `.ai/agents/container-engineer.md`.

## Personal configuration

Set model, provider, approval policy, and MCP servers in `~/.codex/config.toml`. Do not commit them
here. `.codex/config.toml` in the repository is intentionally minimal.

## Commands

Use the same `make` targets as every other tool:

```bash
make doctor
make up
make lint
make test
make ci
```
