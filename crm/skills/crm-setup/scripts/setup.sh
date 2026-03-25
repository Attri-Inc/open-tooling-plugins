#!/usr/bin/env bash
set -euo pipefail

# Open Tooling CRM — Local Setup Script
# Clones the repo, installs dependencies, seeds sample data, and starts the dev server.

REPO_URL="https://github.com/Attri-Inc/open-tooling.git"
INSTALL_DIR="${OPEN_TOOLING_DIR:-$HOME/open-tooling}"
CRM_DIR="$INSTALL_DIR/crm"

# ── Helpers ──────────────────────────────────────────────────────────────────

info()  { printf '\033[1;34m▸ %s\033[0m\n' "$*"; }
ok()    { printf '\033[1;32m✓ %s\033[0m\n' "$*"; }
warn()  { printf '\033[1;33m⚠ %s\033[0m\n' "$*"; }
fail()  { printf '\033[1;31m✗ %s\033[0m\n' "$*"; exit 1; }

# ── Preflight checks ────────────────────────────────────────────────────────

info "Checking prerequisites…"

command -v git  >/dev/null 2>&1 || fail "git is not installed"
command -v node >/dev/null 2>&1 || fail "Node.js is not installed"
command -v npm  >/dev/null 2>&1 || fail "npm is not installed"

NODE_MAJOR=$(node -v | sed 's/v//' | cut -d. -f1)
if [ "$NODE_MAJOR" -lt 18 ]; then
  fail "Node.js >= 18 required (found $(node -v))"
fi
ok "Prerequisites met (Node $(node -v), npm $(npm -v))"

# ── Clone or update ─────────────────────────────────────────────────────────

if [ -d "$CRM_DIR" ]; then
  info "Open Tooling already exists at $INSTALL_DIR — pulling latest…"
  git -C "$INSTALL_DIR" pull --ff-only 2>/dev/null || warn "Could not fast-forward; using existing checkout"
else
  info "Cloning Open Tooling into $INSTALL_DIR…"
  git clone "$REPO_URL" "$INSTALL_DIR"
fi

[ -d "$CRM_DIR" ] || fail "CRM directory not found at $CRM_DIR"
ok "Repo ready at $INSTALL_DIR"

# ── Install dependencies ────────────────────────────────────────────────────

info "Installing CRM dependencies…"
cd "$CRM_DIR"
npm install --no-fund --no-audit
ok "Dependencies installed"

# ── Environment file ────────────────────────────────────────────────────────

if [ ! -f "$CRM_DIR/.env" ]; then
  if [ -f "$CRM_DIR/.env.example" ]; then
    cp "$CRM_DIR/.env.example" "$CRM_DIR/.env"
    ok "Created .env from .env.example"
  else
    warn "No .env.example found — skipping .env creation"
  fi
else
  ok ".env already exists"
fi

# ── Seed sample data ────────────────────────────────────────────────────────

if [ "${SKIP_SEED:-}" != "1" ]; then
  info "Seeding sample data…"
  npm run seed 2>/dev/null && ok "Sample data seeded" || warn "Seed script not available or failed — skipping"
else
  info "Skipping seed (SKIP_SEED=1)"
fi

# ── Write state file ─────────────────────────────────────────────────────────

STATE_DIR="$HOME/.open-tooling"
STATE_FILE="$STATE_DIR/state.json"
mkdir -p "$STATE_DIR"
cat > "$STATE_FILE" <<EOF
{
  "crm_path": "$CRM_DIR",
  "setup_completed_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
ok "State saved to $STATE_FILE"

# ── Create MCP launcher script ──────────────────────────────────────────────

LAUNCHER="$STATE_DIR/start-mcp.sh"
cat > "$LAUNCHER" <<SCRIPT
#!/usr/bin/env bash
cd "$CRM_DIR" && exec npx tsx ./src/mcp.ts
SCRIPT
chmod +x "$LAUNCHER"
ok "MCP launcher created at $LAUNCHER"

# ── Print summary ───────────────────────────────────────────────────────────

echo ""
echo "┌─────────────────────────────────────────────┐"
echo "│  Open Tooling CRM is ready!                 │"
echo "├─────────────────────────────────────────────┤"
echo "│  Location : $CRM_DIR"
echo "│  MCP      : $LAUNCHER"
echo "└─────────────────────────────────────────────┘"
echo ""
