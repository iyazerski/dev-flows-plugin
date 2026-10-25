#!/bin/sh
# Mirror third-party skills into skills/ as plain files, pinned to an upstream release.
# Plugin installers (Codex, Claude Code, Pi, Antigravity) do not reliably resolve git submodules or symlinks,
# so a committed copy is the only layout every harness installs as is.
# Usage: scripts/sync-skills.sh [tag]  (defaults to the latest upstream release)
set -eu

REPO="morganlinton/BeautifulRust"
SKILLS="rust-best-practices"

ROOT=$(cd "$(dirname "$0")/.." && pwd)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT HUP INT TERM

if [ $# -gt 0 ]; then
  tag="$1"
else
  # The latest-release URL redirects to .../releases/tag/<tag>.
  tag=$(curl -fsSLI -o /dev/null -w '%{url_effective}' "https://github.com/$REPO/releases/latest")
  tag="${tag##*/}"
fi

curl -fsSL "https://codeload.github.com/$REPO/tar.gz/refs/tags/$tag" | tar -xz -C "$TMP" --strip-components=1

for skill in $SKILLS; do
  dest="$ROOT/skills/$skill"
  # Replace the whole directory, so files removed upstream are removed here too.
  rm -rf "$dest"
  cp -R "$TMP/skills/$skill" "$dest"
  # The MIT license requires keeping the copyright notice with the copied files.
  cp "$TMP/LICENSE" "$dest/LICENSE"
  printf 'https://github.com/%s/tree/%s/skills/%s\n' "$REPO" "$tag" "$skill" > "$dest/UPSTREAM"
  echo "$skill: synced from $REPO@$tag"
done
