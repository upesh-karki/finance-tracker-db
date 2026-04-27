#!/bin/bash
# migrate-liquibase-tracking.sh
# =====================================================================
# One-time migration script — moves existing Liquibase tracking from
# public.databasechangelog → dbutils.changelog_audit
#
# Run ONCE when upgrading from the old liquibase structure to the new one.
# After this script, Liquibase will use dbutils.changelog_audit for tracking.
# =====================================================================

set -e

source "$(dirname "$0")/.env" 2>/dev/null || true

DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_NAME="${POSTGRES_DB:-finance_tracker}"
DB_USER="${POSTGRES_USER:-finance_user}"
DB_PASS="${POSTGRES_PASSWORD:-finance_pass}"

PSQL="docker exec finance-tracker-postgres psql -U $DB_USER -d $DB_NAME"

echo "=== Liquibase tracking migration: public → dbutils ==="

$PSQL -c "
-- 1. Create dbutils schema
CREATE SCHEMA IF NOT EXISTS dbutils;

-- 2. Create the new tracking table (Liquibase will populate/validate this)
CREATE TABLE IF NOT EXISTS dbutils.changelog_audit (
    id               VARCHAR(255)    NOT NULL,
    author           VARCHAR(255)    NOT NULL,
    filename         VARCHAR(1000)   NOT NULL,
    dateexecuted     TIMESTAMP       NOT NULL DEFAULT NOW(),
    orderexecuted    INT             NOT NULL,
    exectype         VARCHAR(10)     NOT NULL,
    md5sum           VARCHAR(35),
    description      VARCHAR(255),
    comments         VARCHAR(255),
    tag              VARCHAR(255),
    liquibase        VARCHAR(20),
    contexts         VARCHAR(255),
    labels           VARCHAR(255),
    deployment_id    VARCHAR(10),
    PRIMARY KEY (id, author, filename)
);

-- 3. Copy all previously applied changeSets from old tracking tables
INSERT INTO dbutils.changelog_audit
    (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum,
     description, comments, tag, liquibase, contexts, labels, deployment_id)
SELECT DISTINCT
    id, author, filename, dateexecuted, orderexecuted, exectype, md5sum,
    description, comments, tag, liquibase, contexts, labels, deployment_id
FROM public.databasechangelog
ON CONFLICT DO NOTHING;

-- Also copy from ods.databasechangelog if it has entries
INSERT INTO dbutils.changelog_audit
    (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum,
     description, comments, tag, liquibase, contexts, labels, deployment_id)
SELECT DISTINCT
    id, author, filename, dateexecuted, orderexecuted, exectype, md5sum,
    description, comments, tag, liquibase, contexts, labels, deployment_id
FROM ods.databasechangelog
ON CONFLICT DO NOTHING;

SELECT COUNT(*) AS migrated_changesets FROM dbutils.changelog_audit;
"

echo "=== Migration complete. Old tracking tables left intact (safe to drop manually later). ==="
echo "Next step: run 'liquibase update' or './redeploy.sh db' to apply new structure."
