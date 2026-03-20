#!/usr/bin/env bash
set -euo pipefail

log() {
  printf '\n[%s] %s\n' "optimised-memory" "$*"
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1
}

install_apt_utils() {
  if require_cmd unzip && require_cmd zip; then
    log "zip/unzip already available"
    return
  fi

  if ! require_cmd apt-get; then
    log "apt-get not found; install zip/unzip manually for your OS"
    exit 1
  fi

  log "Installing zip/unzip via apt-get"
  sudo apt-get update
  sudo apt-get install -y unzip zip
}

install_bun() {
  export BUN_INSTALL="${BUN_INSTALL:-$HOME/.bun}"
  export PATH="$BUN_INSTALL/bin:$PATH"

  if require_cmd bun; then
    log "Bun already installed: $(bun --version)"
    return
  fi

  log "Installing Bun"
  curl -fsSL https://bun.sh/install | bash
  export PATH="$BUN_INSTALL/bin:$PATH"
  hash -r
  log "Bun installed: $(bun --version)"
}

install_qmd() {
  export BUN_INSTALL="${BUN_INSTALL:-$HOME/.bun}"
  export PATH="$BUN_INSTALL/bin:$PATH"

  log "Installing published QMD package"
  bun install -g @tobilu/qmd
  hash -r

  log "QMD path: $(command -v qmd)"
  qmd --help >/dev/null
  log "QMD help check passed"
}

restart_gateway() {
  if ! require_cmd openclaw; then
    log "openclaw CLI not found on PATH"
    exit 1
  fi

  log "Restarting OpenClaw gateway"
  openclaw gateway restart
  sleep 3
  openclaw gateway status
}

main() {
  install_apt_utils
  install_bun
  install_qmd
  restart_gateway
  log "Install flow completed"
}

main "$@"
