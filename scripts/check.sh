#!/bin/sh
# Check the plugin manifests and skills: valid JSON, one version everywhere, and SKILL.md frontmatter that every
# agent accepts (https://agentskills.io/specification).
set -eu
cd "$(dirname "$0")/.."

status=0
fail() {
	echo "error: $*" >&2
	status=1
}

for file in package.json plugin.json .claude-plugin/plugin.json .claude-plugin/marketplace.json \
	.codex-plugin/plugin.json .agents/plugins/marketplace.json; do
	jq empty "$file" 2>/dev/null || fail "$file is not valid JSON"
done

version=$(jq -r .version package.json)
for file in .claude-plugin/plugin.json .codex-plugin/plugin.json; do
	[ "$(jq -r .version "$file")" = "$version" ] || fail "$file has version $(jq -r .version "$file"), not $version from package.json"
done

for skill in skills/*/; do
	dir=$(basename "$skill")
	file="${skill}SKILL.md"
	[ -f "$file" ] || { fail "$skill has no SKILL.md"; continue; }
	[ "$(head -n 1 "$file")" = "---" ] || { fail "$file doesn't start with frontmatter"; continue; }
	frontmatter=$(awk 'NR > 1 && /^---$/ { exit } NR > 1 { print }' "$file")
	name=$(printf '%s\n' "$frontmatter" | sed -n 's/^name:[[:space:]]*//p')
	[ "$name" = "$dir" ] || fail "$file has name '$name', not its folder name '$dir'"
	printf '%s\n' "$name" | grep -Eqx '[a-z0-9]+(-[a-z0-9]+)*' || fail "$file name must be lowercase words joined by hyphens"
	[ "${#name}" -le 64 ] || fail "$file name is longer than 64 characters"
	printf '%s\n' "$frontmatter" | grep -Eq '^description:[[:space:]]*[^[:space:]]' || fail "$file has no description"
done

[ "$status" = 0 ] && echo "Plugin $version and $(find skills -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ') skills are valid"
exit "$status"
