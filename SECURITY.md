# Security

## Secrets

- `.env` is the only local secret store and is gitignored.
- `.env.example` contains fake values and documents required variable names.
- Never bake secrets into `Containerfile`, `compose.yaml`, images, or committed files.
- Use `make scan` (gitleaks in Podman) before publishing.

## Containers

- Production targets run as a non-root user where the base image allows it.
- Development containers run inside rootless Podman; "root" in a rootless container maps to your
  host user and cannot modify host-owned system files.
- Pin base image versions. Do not introduce `latest` for production images.
- Keep the database port bound to localhost by default; do not expose it publicly.

## Reporting

Open a private security advisory on GitHub or contact the repository owner directly. Do not file a
public issue containing a secret, exploit, or production data.
