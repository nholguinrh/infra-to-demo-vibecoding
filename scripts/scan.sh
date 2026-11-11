#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

info() { printf '==> %s\n' "$*"; }

info "Scanning $ROOT with gitleaks in Podman"
podman run --rm \
  -v "$ROOT:/repo:Z" \
  -w /repo \
  ghcr.io/gitleaks/gitleaks:v8.21.2 \
  detect --source . --no-git --redact -v

info "No leaks reported."
