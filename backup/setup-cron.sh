#!/bin/bash
# =============================================================
# Finance Tracker — Backup Cron Setup
# Installs cron jobs for automated DB backups
#
# Usage: ./backup/setup-cron.sh
# =============================================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_SCRIPT="$SCRIPT_DIR/backup.sh"

echo "Setting up automated backup cron jobs..."

# Remove existing finance-tracker backup crons
crontab -l 2>/dev/null | grep -v "finance-tracker" | crontab - 2>/dev/null || true

# Add new cron jobs
(crontab -l 2>/dev/null; cat << EOF

# Finance Tracker — Full backup at 2 AM daily
0 2 * * * $BACKUP_SCRIPT >> /tmp/finance-tracker-backup.log 2>&1

# Finance Tracker — Schema snapshot at midnight daily
0 0 * * * $BACKUP_SCRIPT --schema >> /tmp/finance-tracker-backup.log 2>&1
EOF
) | crontab -

echo "✅ Cron jobs installed:"
crontab -l | grep "finance-tracker"
echo ""
echo "Logs will appear in: /tmp/finance-tracker-backup.log"
echo "Run manually anytime: $BACKUP_SCRIPT"
