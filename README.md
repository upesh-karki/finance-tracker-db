# finance-tracker-db

Database infrastructure for the Finance Tracker platform.

## What's in here

| Folder | Purpose |
|---|---|
| `docker-compose.yml` | Runs Postgres, pgAdmin, API, and Frontend together |
| `redeploy.sh` | One-command rebuild & restart for any service |
| `backup/` | Scripts to dump and restore the Postgres database |
| `sql/seed-data/` | Dev/test data scripts (not run in production) |
| `sql/reference/` | Human-readable DDL reference — schema docs |

## Quick Start

```bash
# Start everything (first run builds Docker images — takes a few minutes)
./redeploy.sh

# Start only the database
./redeploy.sh db

# Rebuild and restart just the API
./redeploy.sh api

# Rebuild and restart just the frontend
./redeploy.sh frontend
```

## Services

| Service | URL | Credentials |
|---|---|---|
| Frontend | http://localhost:3000 | — |
| API | http://localhost:8080 | — |
| pgAdmin | http://localhost:5050 | admin@finance.local / admin123 |
| Postgres | localhost:5432 | finance_user / finance_pass |

## Database Schema

Schema is managed by **Liquibase** inside `finance-tracker-api`.  
Migrations run automatically on API startup.

Tables:
- `member` — registered users
- `member_detail` — extended profile info
- `expense` — all user expenses with categories
- `savings_goal` — savings goals and targets

See `sql/reference/` for human-readable DDL.

## Backups

```bash
# Create a backup
./backup/backup.sh

# Restore from a backup file
./backup/restore.sh backups/finance_tracker_2026-04-19.sql
```

Backups are saved to `backup/dumps/` (gitignored).

## Prerequisites

- Docker + Docker Compose
- Repos cloned side by side:
  ```
  ~/finance-tracker-api/
  ~/finance-tracker-frontend/
  ~/finance-tracker-db/
  ```
