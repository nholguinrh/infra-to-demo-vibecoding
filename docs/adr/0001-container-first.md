# ADR-0001: Container-first development with Podman

- Status: accepted
- Date: 2026-11-11
- Deciders: maintainers

## Context

Developers use different operating systems and different AI coding tools. Installing language
runtimes, package managers, and databases on each host produces drift, onboarding cost, and
"works on my machine" failures. CI must reproduce development behavior.

## Decision

All application execution — run, lint, format, test, database queries, and CI — happens inside
Podman containers.

- The host provides only `git`, an editor, `podman`, and the AI tool.
- `Makefile` and `scripts/` are the supported interface.
- GitHub Actions installs Podman and runs the same `make ci` used locally.
- Docker and Docker-in-Docker are not supported.

## Consequences

### Positive

- Reproducible environments across Linux/macOS/Windows.
- No host pollution.
- Local and CI behavior share one recipe.
- Database clients and credentials stay inside the container network.

### Negative / trade-offs

- Requires Podman (and `podman machine` on macOS/Windows).
- First image build is slower.
- Developers must learn the `make` targets instead of running runtimes directly.

### Neutral

- Podman has no `podman pod exec`; exec targets containers inside the pod. The scripts resolve the
  container automatically.

## Alternatives considered

1. Host-native development with version managers — rejected: drift and host installs.
2. Docker — rejected: engine decision and licensing/daemon requirements.
3. Cloud-only dev environments — rejected: offline/local workflow and cost.

## Container and tool impact

- Defines `compose.yaml`, `scripts/`, and `make ci`.
- Does not pin an AI tool.
- Proof: `make doctor`, `make up`, `make test`, `make ci`.
