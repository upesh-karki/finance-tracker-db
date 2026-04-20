#!/bin/bash
# =============================================================
# Finance Tracker — Database Backup Script
# Creates a timestamped pg_dump of the finance_tracker database
# Usage: ./backup/backup.sh
# =============================================================

set -e

CONTAINER="finance-tracker-postgres"
DB_NAME="finance_tracker"
DB_USER="finance_user"
DUMP_DIR="$(cd "$(dirname "$0")" && pwd)/dumps"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
FILENAME="${DUMP_DIR}/finance_tracker_${TIMESTAMP}.sql"

mkdir -p "$DUMP_DIR"

echo "📦 Backing up $DB_NAME → $FILENAME"
docker exec "$CONTAINER" pg_dump -U "$DB_USER" "$DB_NAME" > "$FILENAME"

# Keep only the last 10 backups
ls -t "$DUMP_DIR"/*.sql 2>/dev/null | tail -n +11 | xargs rm -f 2>/dev/null || true

echo "✅ Backup complete: $FILENAME"
echo "📁 Total backups: $(ls "$DUMP_DIR"/*.sql 2>/dev/null | wc -l)"
