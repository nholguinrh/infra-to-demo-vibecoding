---
description: Run one SQL statement inside the database container
argument-hint: SQL statement
---

Run the SQL inside the database container, never from a host client:

```bash
make db-sql SQL="$ARGUMENTS"
```

If `$ARGUMENTS` is empty, ask for the statement. Do not print secrets. Do not use this to change
schema by hand; schema changes require a migration.
