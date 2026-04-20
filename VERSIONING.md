# Release Versioning

Finance Tracker uses calendar-based versioning: **YYYY.MM.patch**

| Part | Meaning | Example |
|---|---|---|
| `YYYY` | Year | `2026` |
| `MM` | Month (zero-padded) | `05` |
| `patch` | Increment within the month | `1`, `2`, `3` |

## Current Releases

| Version | Date | Description |
|---|---|---|
| `2026.05.1` | 2026-04-19 | Initial schema — ods/ref/rpt schemas, all core tables, functions, views |

## How Releases Connect

```
finance-tracker-db-test:2026.05.1  (test fixture JAR)
         ↓ test dependency
finance-tracker-api                (DAO layer tests use embedded DB from this JAR)
```

When a new DB version ships (e.g. `2026.05.2`):
1. Update changelogs in `finance-tracker-db`
2. Bump version in `db-test/pom.xml`
3. Run `mvn install` to publish new test JAR locally (or push to GitHub Packages for CI)
4. Update the `<version>` in `finance-tracker-api/pom.xml`
5. Run API tests — Liquibase will apply the new migrations against the embedded container

## Adding a New DB Release

```bash
# 1. Create new release changelog
mkdir -p liquibase/changelog/releases/v1.1
# ... add your changesets ...

# 2. Include it in master
# Edit liquibase/changelog/db.changelog-master.xml

# 3. Bump db-test version
# Edit db-test/pom.xml: <version>2026.05.2</version>

# 4. Run tests
cd db-test && mvn clean test

# 5. Install to local .m2
mvn install -DskipTests

# 6. Update finance-tracker-api dependency version
```
