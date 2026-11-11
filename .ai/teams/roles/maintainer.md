# Maintainer

## Owns

- `AGENTS.md` and `.ai/` as the canonical contract.
- Stack selection and changes in `project.env` (with an ADR).
- CI parity between `make ci` and GitHub Actions.
- `.github/CODEOWNERS` and team membership.
- Release and security decisions.

## Duties

- Keep the contract small and enforceable.
- Reject PRs that introduce Docker, host installs, a second runtime, or tool-specific policy.
- Ensure every adapter references `AGENTS.md`; run `make check-agents`.
- Ensure new stacks follow `docs/adding-a-stack.md` and have tests.
- Rotate secrets if `.env` or a credential is ever committed.
- Approve changes that alter shared infrastructure only after `make ci` is green.

## Does not

- Force a specific AI tool on the team.
- Change the language of an existing project without an ADR.
- Merge unverified "it works" claims.
