# Team roles

The role definitions are tool-neutral charters. Any AI tool or human can act in them.

- [`maintainer`](roles/maintainer.md) — protects the contract, stack decisions, and CI parity
- [`developer`](roles/developer.md) — implements application and stack changes
- [`reviewer`](roles/reviewer.md) — reviews for correctness, security, and evidence

Operational agent behavior is defined separately in `.ai/agents/`:

- architect
- implementer
- verifier
- reviewer
- container-engineer

A human "developer" may use the implementer and verifier agents. A human "reviewer" may use the
reviewer agent. A "maintainer" may use the architect plus reviewer agents.
