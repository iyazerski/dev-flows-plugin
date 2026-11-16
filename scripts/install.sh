#!/bin/sh
# Install everything the Dev Flows MCP servers need. Safe to re-run: installed tools are skipped.
set -eu

if [ "$(uname -s)" != "Darwin" ]; then
  echo "error: this installer supports macOS only (cua-driver is macOS only)" >&2
  exit 1
fi

BIN="$HOME/.local/bin"
export PATH="$BIN:$PATH"

installed() {
  if command -v "$1" >/dev/null 2>&1; then
    echo "$1: already installed"
    return 0
  fi
  echo "$1: installing..."
  return 1
}

command -v curl >/dev/null 2>&1 || { echo "error: curl is required" >&2; exit 1; }

installed lspyx || curl -fsSL https://raw.githubusercontent.com/iyazerski/lspyx/main/install.sh | sh
# gopls needs a Go toolchain at run time too, so skip it on machines without Go.
if command -v go >/dev/null 2>&1; then
  installed gopls || GOBIN="$BIN" go install golang.org/x/tools/gopls@latest
else
  echo "gopls: skipped, Go is not installed"
fi
# --agent none: the plugin declares the browse server, so browse doesn't add it to agent configs too.
# The installer then pairs browse's Chrome extension, opening the Chrome Web Store if it isn't added yet.
installed browse || curl -fsSL https://opencode.ai/browse/install | bash -s -- --agent none
installed cua-driver || curl -fsSL https://cua.ai/driver/install.sh | bash

echo "note: run 'cua-driver permissions grant' once to allow Accessibility and Screen Recording"
