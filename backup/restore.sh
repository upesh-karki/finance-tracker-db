#!/bin/bash
# =============================================================
# Finance Tracker — Database Restore Script
# Usage: ./backup/restore.sh <path-to-dump-file>
# Example: ./backup/restore.sh backup/dumps/finance_tracker_2026-04-19_21-00-00.sql
# =============================================================

set -e

CONTAINER="finance-tracker-postgres"
DB_NAME="finance_tracker"
DB_USER="finance_user"
DUMP_FILE="$1"

if [ -z "$DUMP_FILE" ]; then
    echo "❌ Usage: $0 <path-to-dump-file>"
    echo "   Available dumps:"
    ls "$(dirname "$0")/dumps/"*.sql 2>/dev/null | sed 's/^/   /' || echo "   (none found)"
    exit 1
fi

if [ ! -f "$DUMP_FILE" ]; then
    echo "❌ File not found: $DUMP_FILE"
    exit 1
fi

echo "⚠️  This will OVERWRITE the current $DB_NAME database."
read -p "   Are you sure? (yes/no): " CONFIRM
if [ "$CONFIRM" != "yes" ]; then
    echo "Cancelled."
    exit 0
fi

echo "🔄 Restoring $DB_NAME from $DUMP_FILE ..."
docker exec -i "$CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" < "$DUMP_FILE"
echo "✅ Restore complete."
