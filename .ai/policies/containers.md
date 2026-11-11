# Container policy

**Container-first is the prime directive.** Host tooling is limited to `git`, an editor, `podman`,
and the AI tool.

## Host vs. container

| Task | Host | Container |
|---|---|---|
| `git`, edit files, run `podman`, run AI tool | yes | — |
| Install app dependencies | no | yes |
| Run the app | no | yes |
| Lint / format / test | no | yes |
| Run DB migrations or queries | no | yes |
| Run CI | no | yes (via Podman) |
| Debug with `gdb`, REPL, profiler | no | yes |

Forbidden on the host: `pip`, `uv`, `poetry`, `npm`, `yarn`, `pnpm`, `composer`, `mvn`, `gradle`,
`Rscript`, `pytest`, `mysql`/`mariadb`, `psql`, `php`, `java`, `python` application commands.

## Engine

- **Podman only.** No Docker, Docker Compose, Docker-in-Docker, or a Docker socket.
- Compose is run through `podman compose`, never `docker compose`.
- Containers are rootless where possible; development containers may run as root *inside* a
  rootless container because that maps to the unprivileged host user. Production targets must run
  as a non-root user when the base image allows it.

## Standard flows

```bash
make up
make shell
make test
make lint
make db-sql SQL="SELECT 1;"
make ci
```

Direct Podman is allowed for debugging as long as it is the same container:

```bash
podman ps --filter label=com.docker.compose.project=vibe
podman exec -it <app-container> bash
podman exec -it <db-container> mariadb -u"$DB_USER" -p"$ENVPASSWORD" "$DB_NAME" -e "SELECT 1;"
podman logs -f <container>
podman inspect <container>
```

## Database access

Use `make db` or `make db-sql SQL="..."`. They exec into the DB container, so credentials, client
binaries, and networking stay inside the container network. Never connect from a host-installed
client as the primary workflow.

Migrations belong to the application and run in the app container. `make db-sql` is for inspection
and debugging, not for hand-editing the schema.

## Services and networks

- Add services in `compose.yaml` (shared) and, when stack-specific, `stacks/<stack>/compose.yaml`.
- Every service gets a health check if the app depends on it.
- No service may require a host runtime or a host database.
- Do not publish database ports publicly. The default host binding is for local debugging only.

## CI parity

`make ci` is the single CI recipe. It builds an image and runs lint, format check, and tests inside
it. GitHub Actions installs Podman and calls the same `make ci`. If a check exists only in GitHub
Actions, it is not allowed.
