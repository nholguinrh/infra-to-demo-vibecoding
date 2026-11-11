# Prompt: review a pull request

Act as the `reviewer` role in `.ai/agents/reviewer.md`.

1. Read `AGENTS.md`, the diff, and any linked ADR.
2. Check:
   - policy stayed canonical (no policy copied into a vendor adapter)
   - no AI tool is required of teammates
   - one language/stack remains pinned
   - no host installs, no Docker
   - no secrets, unpinned production images, or dangerous Podman flags
   - DB changes use migrations
   - tests cover new behavior
   - `make ci` / `make check-agents` evidence exists for infrastructure changes
3. Cite `file:line`.
4. Group findings as BLOCKER, MAJOR, MINOR, NIT.
5. End with `approve` or `request changes`.

Do not edit the branch. Do not approve based on claims without evidence.
