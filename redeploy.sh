#!/bin/bash
# =============================================================
# Finance Tracker — Redeploy Script
# Restarts services using pre-built images (run build.sh first)
#
# Usage:
#   ./redeploy.sh           — restart everything + tail logs
#   ./redeploy.sh api       — restart API only
#   ./redeploy.sh frontend  — restart frontend only
#   ./redeploy.sh db        — restart DB + pgAdmin only
#   ./redeploy.sh all       — restart all services + tail logs
#   ./redeploy.sh logs      — tail logs from all services
#   ./redeploy.sh logs api  — tail logs from API only
# =============================================================

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

# Show which image versions are being deployed
show_versions() {
  local api_version frontend_version
  api_version=$(docker inspect finance-tracker-api:latest --format '{{index .Config.Labels "build.version"}}' 2>/dev/null || echo "unknown")
  frontend_version=$(docker inspect finance-tracker-frontend:latest --format '{{index .Config.Labels "build.version"}}' 2>/dev/null || echo "unknown")
  log "API image version:      ${api_version}"
  log "Frontend image version: ${frontend_version}"
}

case "$TARGET" in
  api)
    log "Redeploying API..."
    show_versions
    docker compose up -d --no-deps --pull never api
    ok "API redeployed → http://localhost:8080"
    ;;
  frontend)
    log "Redeploying frontend..."
    show_versions
    docker compose up -d --no-deps --pull never frontend
    ok "Frontend redeployed → http://localhost:3000"
    ;;
  db)
    log "Restarting database services..."
    docker compose up -d postgres pgadmin
    ok "Postgres → localhost:5432"
    ok "pgAdmin  → http://localhost:5050"
    ;;
  logs)
    SERVICE="${2:-}"
    log "Streaming logs${SERVICE:+ for $SERVICE} (Ctrl+C to stop)..."
    if [ -n "$SERVICE" ]; then
      docker compose logs -f --tail=50 "$SERVICE"
    else
      docker compose logs -f --tail=50
    fi
    ;;
  all)
    log "Redeploying all services..."
    show_versions
    docker compose up -d --pull never
    log "Waiting for services to be healthy..."
    sleep 10
    echo ""
    ok "Postgres  → localhost:5432"
    ok "pgAdmin   → http://localhost:5050  (admin@finance.local)"
    ok "API       → http://localhost:8080"
    ok "Frontend  → http://localhost:3000"
    echo ""
    log "Tailing API logs (Ctrl+C to stop)..."
    docker compose logs -f api
    ;;
  *)
    err "Unknown target '$TARGET'. Use: all | api | frontend | db"
    ;;
esac
