#!/bin/bash
# =============================================================
# Finance Tracker — Image Build Script
# Builds versioned Docker images for API and frontend
#
# Usage:
#   ./build.sh              — build both with version from .env
#   ./build.sh api          — build API only
#   ./build.sh frontend     — build frontend only
#   ./build.sh api 2026.04.2  — build API with specific version
# =============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET="${1:-all}"
OVERRIDE_VERSION="$2"

# Load .env
if [ -f "$SCRIPT_DIR/.env" ]; then
  export $(grep -v '^#' "$SCRIPT_DIR/.env" | xargs)
fi

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log()  { echo -e "${CYAN}[build]${NC} $1"; }
ok()   { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
err()  { echo -e "${RED}[✗]${NC} $1"; exit 1; }

MAVEN_SECRET_ARG=""
if [ -f "$HOME/.m2/settings.xml" ]; then
  MAVEN_SECRET_ARG="--secret id=maven_settings,src=$HOME/.m2/settings.xml"
fi

build_api() {
  local version="${OVERRIDE_VERSION:-${API_VERSION:-latest}}"
  local git_sha
  git_sha=$(git -C "$SCRIPT_DIR/../FinancialTrackerAPI" rev-parse --short HEAD 2>/dev/null || echo "unknown")
  local full_tag="finance-tracker-api:${version}"
  local sha_tag="finance-tracker-api:${version}-${git_sha}"

  log "Building API image → ${full_tag} (${git_sha})"
  DOCKER_BUILDKIT=1 docker build --no-cache \
    $MAVEN_SECRET_ARG \
    --label "git.sha=${git_sha}" \
    --label "build.version=${version}" \
    --label "build.date=$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    -t "${full_tag}" \
    -t "${sha_tag}" \
    -t "finance-tracker-api:latest" \
    "$SCRIPT_DIR/../FinancialTrackerAPI"

  ok "API built → ${full_tag}"
  ok "API built → ${sha_tag}"
  ok "API built → finance-tracker-api:latest"

  # Update .env with new version
  sed -i "s/^API_VERSION=.*/API_VERSION=${version}/" "$SCRIPT_DIR/.env"
}

build_frontend() {
  local version="${OVERRIDE_VERSION:-${FRONTEND_VERSION:-latest}}"
  local git_sha
  git_sha=$(git -C "$SCRIPT_DIR/../react-finance-tracker-frontend" rev-parse --short HEAD 2>/dev/null || echo "unknown")
  local full_tag="finance-tracker-frontend:${version}"
  local sha_tag="finance-tracker-frontend:${version}-${git_sha}"

  log "Building frontend image → ${full_tag} (${git_sha})"
  docker build --no-cache \
    --label "git.sha=${git_sha}" \
    --label "build.version=${version}" \
    --label "build.date=$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    -t "${full_tag}" \
    -t "${sha_tag}" \
    -t "finance-tracker-frontend:latest" \
    "$SCRIPT_DIR/../react-finance-tracker-frontend"

  ok "Frontend built → ${full_tag}"
  ok "Frontend built → ${sha_tag}"

  # Update .env with new version
  sed -i "s/^FRONTEND_VERSION=.*/FRONTEND_VERSION=${version}/" "$SCRIPT_DIR/.env"
}

case "$TARGET" in
  api)      build_api ;;
  frontend) build_frontend ;;
  all)      build_api && build_frontend ;;
  *)        err "Unknown target '$TARGET'. Use: all | api | frontend" ;;
esac
