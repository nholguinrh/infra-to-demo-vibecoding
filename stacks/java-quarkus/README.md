# Stack: Java + Quarkus

- Java 21
- Quarkus 3.17
- Maven
- QuarkusTest + REST Assured

## Use

```bash
make init STACK=java-quarkus
make build
make up
make test
make shell
```

Open <http://localhost:8080/health>. Dev mode runs `mvn quarkus:dev` with live reload.

## Add a dependency

Edit `template/pom.xml`, then:

```bash
make build
make test
```

## Production

```bash
podman build --target prod -t vibe/java-quarkus:prod -f stacks/java-quarkus/Containerfile .
```

The `prod` stage runs the Quarkus fast-jar as UID 1001.
