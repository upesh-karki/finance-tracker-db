#!/bin/bash
# =============================================================
# Finance Tracker — Database Backup Script
# Creates timestamped pg_dump + schema-only changelog entry
#
# Usage:
#   ./backup/backup.sh            — full backup
#   ./backup/backup.sh --schema   — schema-only dump (for changelog)
# =============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONTAINER="finance-tracker-postgres"
DB_NAME="finance_tracker"
DB_USER="finance_user"
DUMP_DIR="$SCRIPT_DIR/dumps"
SCHEMA_LOG_DIR="$SCRIPT_DIR/schema-changelog"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
DATE=$(date +"%Y-%m-%d")
MODE="${1:-}"

mkdir -p "$DUMP_DIR"
mkdir -p "$SCHEMA_LOG_DIR"

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

log()  { echo -e "${CYAN}[backup]${NC} $1"; }
ok()   { echo -e "${GREEN}[✓]${NC} $1"; }
err()  { echo -e "${RED}[✗]${NC} $1"; exit 1; }

# Check container is running
if ! docker ps --format '{{.Names}}' | grep -q "^${CONTAINER}$"; then
  err "Container $CONTAINER is not running"
fi

if [ "$MODE" = "--schema" ]; then
  # Schema-only dump for changelog tracking
  SCHEMA_FILE="$SCHEMA_LOG_DIR/schema_${TIMESTAMP}.sql"
  log "Capturing schema snapshot → $SCHEMA_FILE"
  docker exec "$CONTAINER" pg_dump -U "$DB_USER" "$DB_NAME" \
    --schema-only --no-owner --no-acl \
    -n ods -n ref -n rpt > "$SCHEMA_FILE"
  ok "Schema snapshot saved: $SCHEMA_FILE"

  # Keep last 30 schema snapshots
  ls -t "$SCHEMA_LOG_DIR"/schema_*.sql 2>/dev/null | tail -n +31 | xargs rm -f 2>/dev/null || true
else
  # Full data backup
  FILENAME="$DUMP_DIR/finance_tracker_${TIMESTAMP}.sql"
  log "Backing up $DB_NAME → $FILENAME"
  docker exec "$CONTAINER" pg_dump -U "$DB_USER" "$DB_NAME" \
    --no-owner --no-acl > "$FILENAME"

  # Keep last 14 backups (2 weeks)
  ls -t "$DUMP_DIR"/finance_tracker_*.sql 2>/dev/null | tail -n +15 | xargs rm -f 2>/dev/null || true

  # Also capture schema snapshot on every full backup
  SCHEMA_FILE="$SCHEMA_LOG_DIR/schema_${TIMESTAMP}.sql"
  docker exec "$CONTAINER" pg_dump -U "$DB_USER" "$DB_NAME" \
    --schema-only --no-owner --no-acl \
    -n ods -n ref -n rpt > "$SCHEMA_FILE"

  ok "Full backup: $FILENAME"
  ok "Schema snapshot: $SCHEMA_FILE"
  log "Total full backups: $(ls "$DUMP_DIR"/*.sql 2>/dev/null | wc -l)/14"
fi
