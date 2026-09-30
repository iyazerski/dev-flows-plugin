#!/bin/sh
# Install everything the Dev Flows MCP servers need. Safe to re-run: installed tools are skipped,
# and the running mcp-proxy is only restarted when its chrome-devtools entry changes.
set -eu

if [ "$(uname -s)" != "Darwin" ]; then
  echo "error: this installer supports macOS only (mcp-proxy runs as a launchd agent)" >&2
  exit 1
fi

BIN="$HOME/.local/bin"
LABEL="com.github.tbxark.mcp-proxy"
ADDR="127.0.0.1:8765"
CONFIG="$HOME/.config/mcp-proxy/config.json"
PLIST="$HOME/Library/LaunchAgents/$LABEL.plist"
LOG="$HOME/Library/Logs/mcp-proxy.log"
DOMAIN="gui/$(id -u)"

PATH="$BIN:$PATH"
export PATH

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT HUP INT TERM

require() {
  command -v "$1" >/dev/null 2>&1 || { echo "error: $1 is required ($2)" >&2; exit 1; }
}

installed() {
  if command -v "$1" >/dev/null 2>&1; then
    echo "$1: already installed"
    return 0
  fi
  echo "$1: installing..."
  return 1
}

install_mcp_proxy() {
  repo="https://github.com/TBXark/mcp-proxy"
  case "$(uname -m)" in
    arm64) arch="arm64" ;;
    x86_64) arch="amd64" ;;
    *) echo "error: unsupported architecture $(uname -m)" >&2; exit 1 ;;
  esac
  # Release assets embed the version, so resolve it from the latest-release redirect.
  tag=$(curl -fsSLI -o /dev/null -w '%{url_effective}' "$repo/releases/latest")
  version="${tag##*/v}"
  asset="mcp-proxy_${version}_darwin_${arch}.tar.gz"
  curl -fsSL -o "$TMP/$asset" "$repo/releases/download/v$version/$asset"
  curl -fsSL -o "$TMP/checksums.txt" "$repo/releases/download/v$version/mcp-proxy_${version}_checksums.txt"
  (cd "$TMP" && grep " $asset\$" checksums.txt | shasum -a 256 -c -)
  tar -xzf "$TMP/$asset" -C "$TMP" mcp-proxy
  mkdir -p "$BIN"
  install -m 755 "$TMP/mcp-proxy" "$BIN/mcp-proxy"
}

require curl "install curl"
require jq "install jq"

installed lspyx || curl -fsSL https://raw.githubusercontent.com/iyazerski/lspyx/main/install.sh | sh
if ! installed chrome-devtools-mcp; then
  require npm "install Node.js"
  npm install -g chrome-devtools-mcp@latest
fi
installed mcp-proxy || install_mcp_proxy
installed cua-driver || curl -fsSL https://cua.ai/driver/install.sh | bash

mkdir -p "$(dirname "$CONFIG")" "$(dirname "$PLIST")" "$(dirname "$LOG")"

if [ ! -f "$CONFIG" ]; then
  cat > "$CONFIG" <<EOF
{
  "mcpProxy": {
    "baseURL": "http://$ADDR",
    "addr": "$ADDR",
    "name": "mcp-proxy",
    "version": "1.0.0",
    "type": "streamable-http"
  },
  "mcpServers": {}
}
EOF
fi

CONFIGURED_ADDR=$(jq -r '.mcpProxy.addr' "$CONFIG")
if [ "$CONFIGURED_ADDR" != "$ADDR" ]; then
  echo "warning: $CONFIG listens on $CONFIGURED_ADDR, but the plugin expects $ADDR" >&2
fi

# Upsert only the chrome-devtools entry, so servers added by other projects are kept.
# --workspace lets file-writing tools save under $HOME: a shared server cannot use per-client MCP roots.
# Telemetry and update checks are off because each spawns an extra node process.
# autoReconnect restarts chrome-devtools-mcp after 3 failed pings if it exits.
jq --arg command "$(command -v chrome-devtools-mcp)" --arg workspace "--workspace=$HOME" '
  .mcpServers["chrome-devtools"] = {
    command: $command,
    args: ["--autoConnect", "--no-usage-statistics", $workspace],
    env: {CHROME_DEVTOOLS_MCP_NO_UPDATE_CHECKS: "1"},
    timeout: "300s",
    options: {autoReconnect: true, pingInterval: "5s"}
  }
' "$CONFIG" > "$TMP/config.json"

CONFIG_CHANGED=false
if ! cmp -s "$TMP/config.json" "$CONFIG"; then
  cp "$TMP/config.json" "$CONFIG"
  CONFIG_CHANGED=true
fi

if ! launchctl print "$DOMAIN/$LABEL" >/dev/null 2>&1; then
  # launchd starts agents with a minimal PATH, so pass the current one for server shebangs like node.
  cat > "$PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>$LABEL</string>
  <key>ProgramArguments</key>
  <array>
    <string>$(command -v mcp-proxy)</string>
    <string>-config</string>
    <string>$CONFIG</string>
  </array>
  <key>EnvironmentVariables</key>
  <dict>
    <key>PATH</key>
    <string>$PATH</string>
  </dict>
  <key>RunAtLoad</key>
  <true/>
  <key>KeepAlive</key>
  <true/>
  <key>StandardOutPath</key>
  <string>$LOG</string>
  <key>StandardErrorPath</key>
  <string>$LOG</string>
</dict>
</plist>
EOF
  launchctl bootstrap "$DOMAIN" "$PLIST"
  echo "mcp-proxy: started as launchd agent $LABEL"
elif [ "$CONFIG_CHANGED" = true ]; then
  launchctl kickstart -k "$DOMAIN/$LABEL"
  echo "mcp-proxy: restarted to apply $CONFIG"
else
  echo "mcp-proxy: running, config unchanged"
fi

echo "note: run 'cua-driver permissions grant' once to allow Accessibility and Screen Recording"
echo "chrome-devtools-mcp is shared at http://$CONFIGURED_ADDR/chrome-devtools/mcp"
