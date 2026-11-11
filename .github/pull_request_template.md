## Summary

<!-- What does this PR do, and why? Keep it to one concern. -->

## Scope

- [ ] Application code (`app/`)
- [ ] Language stack (`stacks/`)
- [ ] Shared infrastructure (`compose.yaml`, `scripts/`, `.github/`)
- [ ] AI contract (`.ai/`, adapters, `AGENTS.md`)
- [ ] Documentation only

## Pinned stack

<!-- Copy STACK from project.env. This PR must not change it without an ADR. -->

## Container evidence

Paste exact commands and results:

```text
$ make lint
...

$ make test
...

$ make ci          # required for stack/infrastructure/AI contract changes
...

$ make check-agents  # required for adapter/AI contract changes
...
```

## Checklist

- [ ] No host runtime, package manager, or database was installed.
- [ ] No Docker/`docker compose` was added.
- [ ] The language stack in `project.env` is unchanged (or an ADR is linked).
- [ ] No AI tool is required of teammates.
- [ ] Policy was changed in `AGENTS.md`/`.ai/`, not in a vendor adapter.
- [ ] No secret, `.env`, generated artifact, or local config is included.
- [ ] Documentation updated if commands, ports, or workflow changed.

## AI tool used (optional)

<!-- Never required. Any tool is allowed. Do not include personal model/provider settings. -->

## Related issue / ADR

Closes #
