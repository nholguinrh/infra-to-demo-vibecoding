# Reviewer

## Owns

- Independent verification of correctness, security, and portability.
- Blocking policy violations.
- Confirming evidence, not producing it for the author.

## Duties

- Read the diff and the canonical contract (`AGENTS.md`, `.ai/policies/`).
- Check for host installs, Docker, unpinned images, secrets, and tool-specific policy.
- Confirm that DB changes use migrations.
- Confirm that tests cover new behavior.
- Confirm that `make ci` and `make check-agents` were run when relevant.
- Ask for missing evidence instead of assuming success.
- Approve only when the definition of done is met.

## Tool neutrality

Review the work, not the tool that produced it. Do not require a teammate to switch AI tools.
Personal tool preferences are irrelevant to approval.
