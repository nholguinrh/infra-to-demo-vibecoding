# Stack: PHP + Drupal

- Drupal 11 (official image)
- PHP 8.3 + Apache
- Composer for custom code and dev tooling

## How this stack is shaped

The Drupal core ships **inside the image**. Your project code lives in `app/`:

```
app/
  composer.json
  modules/custom/...
  themes/custom/...
```

`compose.yaml` mounts the whole `app/` at `/workspace` (for Composer/validation) and mounts custom
modules and themes into the running Drupal tree:

- `app/modules/custom` -> `/var/www/html/modules/custom`
- `app/themes/custom`  -> `/var/www/html/themes/custom`

Core and contrib are never vendored into this repository.

## Use

```bash
make init STACK=php-drupal
make build
make up
make test
make shell
```

Open <http://localhost:8080>. The first Drupal install runs in the browser; the DB host is `db`,
database/user `vibe`, password from `ENVPASSWORD` in `.env`.

## Database settings

Drupal's `settings.php` is part of core. Add an environment-driven include (for example
`settings.local.php` loaded from `settings.php`) that reads `DB_HOST`, `DB_NAME`, `DB_USER`, and
`DB_PASSWORD` from the container environment. Do not commit credentials.

## Add a dependency

```bash
make shell
composer require --dev drupal/core-dev
```

Then record the change in `composer.json` / `composer.lock` in `app/` and rebuild with `make build`.

## Production

```bash
podman build --target prod -t vibe/php-drupal:prod -f stacks/php-drupal/Containerfile .
```

The Apache master process keeps its upstream entrypoint; the application code runs as the image's
unprivileged Apache user. This is the documented exception to the non-root stage rule.
