#!/usr/bin/env bash
set -euo pipefail
# shellcheck source=lib.sh
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/lib.sh"

query="${*:-}"
container="$(container_for db)"

: "${DB_USER:?DB_USER is not set in project.env}"
: "${DB_NAME:?DB_NAME is not set in project.env}"
: "${ENVPASSWORD:?ENVPASSWORD is not set in .env}"

if [[ -n "$query" ]]; then
  info "SQL in $container: $query"
  exec_it "$container" mariadb -u"$DB_USER" -p"$ENVPASSWORD" "$DB_NAME" -e "$query"
else
  if [[ ! -t 0 ]]; then
    die 'No SQL provided. Use: make db-sql SQL="SELECT 1;"'
  fi
  info "Interactive MariaDB client in $container (user $DB_USER, database $DB_NAME)"
  exec_it "$container" mariadb -u"$DB_USER" -p"$ENVPASSWORD" "$DB_NAME"
fi
