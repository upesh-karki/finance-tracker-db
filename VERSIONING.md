# Release Versioning

Finance Tracker uses calendar-based versioning: **YYYY.MM.patch**

| Part | Meaning | Example |
|---|---|---|
| `YYYY` | Year | `2026` |
| `MM` | Month (zero-padded) | `04` |
| `patch` | Increment within the month | `1`, `2`, `3` |

## SNAPSHOT vs Release

| Type | Format | Behaviour | When to use |
|---|---|---|---|
| **SNAPSHOT** | `2026.04.1-SNAPSHOT` | Freely overwritable in GitHub Packages | During active development |
| **Release** | `2026.04.1` | Immutable — cannot be overwritten | When cutting a stable release for consumption |

### Development workflow (day-to-day)
- `db-test/pom.xml` version: `2026.04.1-SNAPSHOT`
- Every merge to `main` redeploys the SNAPSHOT — no conflict, always latest
- `finance-tracker-api` depends on `2026.04.1-SNAPSHOT` and uses `-U` to force pull latest

### Cutting a release
1. Remove `-SNAPSHOT` from `db-test/pom.xml`: `2026.04.1-SNAPSHOT` → `2026.04.1`
2. Update `finance-tracker-api/pom.xml` dependency to `2026.04.1`
3. Merge — immutable release JAR is published
4. Start next cycle: bump to `2026.05.1-SNAPSHOT`

## Current Versions

| Artifact | Version | Type |
|---|---|---|
| `finance-tracker-db-test` | `2026.04.1-SNAPSHOT` | Snapshot (active dev) |
| `finance-tracker-api` | `2026.04.1` | Release |

## How Repos Connect

```
finance-tracker-db  →  publishes finance-tracker-db-test:2026.04.1-SNAPSHOT
                                        ↓ test dependency (-U to always pull latest)
                        finance-tracker-api  (uses SNAPSHOT in test scope)
```
