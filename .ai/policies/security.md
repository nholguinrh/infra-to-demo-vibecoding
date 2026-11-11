# Security policy for agents

## Secrets

- Never commit `.env`, tokens, private keys, credentials, or production data.
- `.env.example` documents variable names with fake values.
- Compose reads secrets from the environment. Do not bake them into images or committed YAML.
- Do not paste secrets into an AI prompt, issue, PR, or log. If a secret is exposed, rotate it and
  report it privately.
- Run `make scan` before publishing.

## Images

- Prefer pinned image versions and digests. Do not add `latest` for production images.
- Production stages run as non-root when the base image allows it.
- Do not add `--privileged`, host PID/network namespaces, or host mounts outside the project.
- Keep build contexts small with `.containerignore`; never copy `.env` into an image.

## Network and data

- Bind local development ports to localhost where possible.
- Do not expose databases to the public internet.
- Use the compose network for app/database traffic.
- Back up before destructive volume operations (`make clean` deletes volumes).

## Supply chain

- Use the package manager already selected by the stack. Do not add a second one.
- Commit lockfiles when the stack produces them.
- Review new dependencies for maintenance and license before adding them.

## AI tool safety

- Personal model choices, API keys, and MCP servers stay in the user's home config.
- Never commit an AI provider API key.
- Treat AI output as untrusted code: review it, run it in the container, and verify with tests.
- Use the read-only/reviewer role for security-sensitive reviews.
