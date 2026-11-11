# Stack: R + Plumber

- R 4.4
- Plumber HTTP API
- testthat

## Use

```bash
make init STACK=r-plumber
make build
make up
make test
make shell
```

Open <http://localhost:8000/health>.

## Add a dependency

Edit the `install.packages(...)` line in the `Containerfile`, then rebuild:

```bash
make build
make test
```

Do not install R packages on the host. The container is the environment.

## Layout

```
app/
  plumber.R
  R/hello.R
  tests/testthat/...
```

## Production

```bash
podman build --target prod -t vibe/r-plumber:prod -f stacks/r-plumber/Containerfile .
```

The `prod` stage runs as UID 1001.
