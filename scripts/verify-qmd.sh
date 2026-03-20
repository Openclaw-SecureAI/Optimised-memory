#!/usr/bin/env bash
set -euo pipefail

export BUN_INSTALL="${BUN_INSTALL:-$HOME/.bun}"
export PATH="$BUN_INSTALL/bin:$PATH"

log() {
  printf '\n[%s] %s\n' "optimised-memory" "$*"
}

fail() {
  printf '\n[%s] ERROR: %s\n' "optimised-memory" "$*" >&2
  exit 1
}

command -v bun >/dev/null 2>&1 || fail "bun not found"
command -v qmd >/dev/null 2>&1 || fail "qmd not found"
command -v openclaw >/dev/null 2>&1 || fail "openclaw not found"

log "bun version: $(bun --version)"
log "qmd path: $(command -v qmd)"
qmd --help >/dev/null || fail "qmd help failed"
log "qmd help works"

log "gateway status"
openclaw gateway status

log "direct CLI memory search sanity (may be denied by scope if no session context)"
openclaw memory search --query "CyberAtlas" --max-results 3 || true

cat <<'EOF'

Next real-session verification:
- run memory_search from an actual direct OpenClaw chat/session
- confirm the result shows:
  provider: "qmd"
  model: "qmd"

If CLI says scope denied with channel/chatType unknown, that is not necessarily a broken install.
EOF
