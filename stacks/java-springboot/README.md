# Stack: Java + Spring Boot

- Java 21
- Spring Boot 3.4
- Maven
- JUnit 5 + MockMvc

## Files

- `Containerfile` — dependency cache, `dev`, `build`, `prod` stages
- `stack.env` — Maven commands used by `make lint/test`
- `compose.yaml` — mounts `app/` and runs `mvn spring-boot:run`
- `template/` — hello-world app copied into `app/` by `make init`

## Use

```bash
make init STACK=java-springboot
make build
make up
make test
make shell
```

Open <http://localhost:8080/health>.

## Add a dependency

Edit `template/pom.xml`, then:

```bash
make build
make test
```

The dev image caches Maven dependencies during build. Do not run `mvn` on the host.

## Production

```bash
podman build --target prod -t vibe/java-springboot:prod -f stacks/java-springboot/Containerfile .
```

The `prod` stage runs as UID 1001.
