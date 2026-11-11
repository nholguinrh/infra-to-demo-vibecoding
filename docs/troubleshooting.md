# Troubleshooting

## `podman compose` says no provider

Podman delegates compose to an external provider. Install one:

```bash
# preferred on most Linux distributions
pipx install podman-compose
# or your distro package
sudo dnf install podman-compose
sudo apt-get install podman-compose
```

Check:

```bash
podman compose version
make doctor
```

## `make up` complains about missing `.env`

`make up` creates `.env` from `.env.example` on first run. If you removed it:

```bash
cp .env.example .env
```

Change both passwords before using the database.

## Two clones collide on container names or ports

Every clone ships with `COMPOSE_PROJECT_NAME=vibe` and DB host port `3307`. If you run two clones
at the same time on one host, change `COMPOSE_PROJECT_NAME`, `APP_PORT`, and `DB_PORT_HOST` in the
second clone's `project.env`. This also avoids pod name collisions (`pod_vibe`).

## Port already in use

Change the host port only, not the container port:

```bash
APP_PORT=8001 make up
```

Or edit `APP_PORT` in `project.env` and run `make up`. The database host port is `DB_PORT_HOST`
(default `3307`).

## Permission denied on mounted files

- On SELinux hosts, use `:Z` in the compose volume (already done in the shipped stacks).
- In rootless Podman, a root process inside the container maps to your host user; files should be
  writable. If not, check that you are not using an unrelated `userns` configuration.
- Do not solve this with `--privileged`.

## `make test` says no running container

Start the stack first:

```bash
make up
make test
```

CI does not need a running stack; it builds and runs an ephemeral container.

## Database is not ready

The app depends on a MariaDB health check. If the app starts too early, wait a few seconds:

```bash
make logs SERVICE=db
make ps
```

Then retry. If the DB volume is corrupt, `make clean` deletes the volume (data loss).

## `.env` password contains special characters

Compose and the DB client read it from the environment. If you use a shell command with `-p`, quote
it. `make db-sql` handles quoting for you. Prefer `MYSQL_PWD` for scripts:

```bash
podman exec -it -e MYSQL_PWD="$ENVPASSWORD" <db> mariadb -u"$DB_USER" "$DB_NAME"
```

## Drupal `composer validate` fails

`composer validate` runs in `app/`, which must contain `composer.json`. If you replaced the template,
keep a valid Composer manifest. Core is in the image; do not vendor Drupal core into `app/`.

## Maven or R builds are slow the first time

The first image build downloads dependencies. Later builds reuse layers until the manifest changes.
To force a clean dependency install:

```bash
podman build --no-cache --target dev -f stacks/<stack>/Containerfile .
```

## GitHub Actions passes but local CI fails (or vice versa)

They run the same target:

```bash
make ci
```

Differences are usually network, a stale local image, or uncommitted files. Rebuild:

```bash
podman rmi localhost/vibe/<stack>:ci
make ci
```

## macOS / Windows

Use `podman machine` and run everything inside the Podman VM through the same commands. Do not
install language runtimes on the host. Mount your project inside the machine-supported workspace.

## I am tempted to install a tool on the host

Stop. Add it to the stack `Containerfile`, rebuild, and document it. The host is not the
environment.
