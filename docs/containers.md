# Containers

## Rules

- Podman only. No Docker, Docker Compose, Docker-in-Docker, or Docker socket.
- The host has `git`, an editor, `podman`, and the AI tool. Nothing else.
- Application runtimes, package managers, databases, and test tools live in images.
- CI runs through `make ci`; GitHub Actions installs Podman and calls the same target.

## Compose model

`compose.yaml` defines the shared app and MariaDB services. Each stack adds a fragment:

```bash
podman compose \
  --env-file project.env \
  --env-file .env \
  -f compose.yaml \
  -f stacks/python-fastapi/compose.yaml \
  up -d
```

`make up` runs exactly that, with the stack from `project.env`.

Container names are generated. Never hardcode them. Use the labels:

```bash
podman ps --filter label=com.docker.compose.project=vibe
podman ps --filter label=com.docker.compose.service=app
podman ps --filter label=com.docker.compose.service=db
```

## Shells

```bash
make shell                 # app container
make shell SERVICE=db      # database container
```

Direct:

```bash
podman exec -it "$(podman ps -q --filter label=com.docker.compose.service=app)" bash
```

## Tests and lint

```bash
make test
make lint
make fmt
```

They exec the stack commands inside the running app container. For a one-off command:

```bash
make shell
pytest -q tests/test_health.py
```

## Database access

One statement:

```bash
make db-sql SQL="SELECT VERSION();"
make db-sql SQL="SHOW TABLES;"
```

Under the hood:

```bash
podman exec -it "$(podman ps -q --filter label=com.docker.compose.service=db)" \
  mariadb -u"$DB_USER" -p"$ENVPASSWORD" "$DB_NAME" -e "SELECT VERSION();"
```

Interactive:

```bash
make db
```

The password is read from `.env` (`ENVPASSWORD`). For a safer variant that avoids the password in
the process list, exec with `MYSQL_PWD`:

```bash
podman exec -it -e MYSQL_PWD="$ENVPASSWORD" <db-container> \
  mariadb -u"$DB_USER" "$DB_NAME"
```

Schema changes must be migrations in the application. `make db` is for debugging.

## Volumes and SELinux

On SELinux hosts, bind mounts use `:Z` in compose fragments. If you add a mount manually and get
permission errors, add `:Z` (private label) or `:z` (shared label).

```bash
podman run --rm -v "$PWD/app:/workspace:Z" -w /workspace <image> sh
```

## Dev vs. production images

- `dev` target: includes test/lint dependencies, no application source baked in, source mounted at
  runtime, may run as root inside rootless Podman.
- `prod` target: copies `app/`, installs only runtime dependencies, runs as a non-root user where
  possible.

```bash
podman build --target prod -t vibe/<stack>:prod -f stacks/<stack>/Containerfile .
```

## CI

```bash
make ci
```

Steps:

1. AI contract check inside a `bash` container.
2. `podman build --target dev`.
3. Lint and format check in the image with `app/` mounted.
4. Tests in the image with `app/` mounted.

If `app/` is still empty, CI validates the stack template instead (useful for the skeleton repo).

## Debugging

```bash
make ps
make logs SERVICE=app
podman inspect <container>
podman stats
podman exec -it <container> sh
```

Never "fix" a container problem by installing the missing tool on the host. Add it to the
`Containerfile` and rebuild.
