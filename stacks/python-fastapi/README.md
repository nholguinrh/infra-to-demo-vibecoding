# Stack: Python + FastAPI

- Python 3.12
- FastAPI + Uvicorn
- pytest + httpx for tests
- ruff for lint and format

## Files

- `Containerfile` — `dev` and `prod` stages
- `stack.env` — commands used by `make lint/test/fmt`
- `compose.yaml` — mounts `app/` and runs the dev server
- `template/` — hello-world app copied into `app/` by `make init`

## Use

```bash
make init STACK=python-fastapi
make build
make up
make test
make shell
```

## Add a dependency

Edit `template/requirements.txt` or `template/requirements-dev.txt`, then:

```bash
make build
make test
```

Do not `pip install` on the host or in a running container as the source of truth.

## Production

```bash
podman build --target prod -t vibe/python-fastapi:prod -f stacks/python-fastapi/Containerfile .
```

The `prod` stage runs as UID 1001.
