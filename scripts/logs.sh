#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=lib.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

service="${1:-}"
if [[ -n "$service" ]]; then
  compose logs -f "$service"
else
  compose logs -f
fi
