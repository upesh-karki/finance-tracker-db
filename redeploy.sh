#!/bin/bash
# ============================================================
# finance-tracker redeploy script
# Usage:
#   ./redeploy.sh          — rebuild & restart everything
#   ./redeploy.sh api      — rebuild & restart API only
#   ./redeploy.sh frontend — rebuild & restart frontend only
#   ./redeploy.sh db       — restart DB + pgAdmin only
# ============================================================

set -e

COMPOSE_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="${1:-all}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log()  { echo -e "${CYAN}[redeploy]${NC} $1"; }
ok()   { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[✗]${NC} $1"; exit 1; }

cd "$COMPOSE_DIR"

case "$TARGET" in
  api)
    log "Rebuilding API..."
    docker compose build --no-cache api
    docker compose up -d --no-deps api
    ok "API redeployed → http://localhost:8080"
    ;;
  frontend)
    log "Rebuilding frontend..."
    docker compose build --no-cache frontend
    docker compose up -d --no-deps frontend
    ok "Frontend redeployed → http://localhost:3000"
    ;;
  db)
    log "Restarting database services..."
    docker compose up -d postgres pgadmin
    ok "Postgres → localhost:5432"
    ok "pgAdmin  → http://localhost:5050"
    ;;
  all)
    log "Rebuilding and restarting all services..."
    docker compose build --no-cache
    docker compose up -d
    log "Waiting for services to be healthy..."
    sleep 10
    echo ""
    ok "Postgres  → localhost:5432"
    ok "pgAdmin   → http://localhost:5050  (admin@finance.local / admin123)"
    ok "API       → http://localhost:8080/api/v1/members"
    ok "Frontend  → http://localhost:3000"
    echo ""
    log "Tailing API logs (Ctrl+C to stop)..."
    docker compose logs -f api
    ;;
  *)
    err "Unknown target '$TARGET'. Use: all | api | frontend | db"
    ;;
esac
