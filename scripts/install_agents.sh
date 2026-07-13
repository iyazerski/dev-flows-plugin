#!/usr/bin/env bash

set -euo pipefail

readonly REPOSITORY="iyazerski/dev-flows-plugin"
readonly DEFAULT_REF="main"

ref="$DEFAULT_REF"

usage() {
  echo "Usage: install_agents.sh [--ref <branch|tag|commit>]"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --ref)
      if [[ $# -lt 2 ]]; then
        echo "--ref requires a branch, tag, or commit." >&2
        exit 2
      fi
      ref="$2"
      shift 2
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

readonly archive_url="https://codeload.github.com/${REPOSITORY}/tar.gz/${ref}"
readonly codex_home="${CODEX_HOME:-${HOME}/.codex}"
readonly destination="${codex_home}/agents"

temporary_directory="$(mktemp -d)"
trap 'rm -rf "$temporary_directory"' EXIT

archive_path="${temporary_directory}/repository.tar.gz"
extract_directory="${temporary_directory}/repository"
mkdir -p "$extract_directory"

curl -fsSL "$archive_url" -o "$archive_path"
tar -xzf "$archive_path" -C "$extract_directory"

shopt -s nullglob
archive_roots=("$extract_directory"/*)
if [[ ${#archive_roots[@]} -ne 1 || ! -d "${archive_roots[0]}" ]]; then
  echo "Expected the GitHub archive to contain one repository root." >&2
  exit 1
fi

source_directory="${archive_roots[0]}/.codex/agents"
agent_files=("$source_directory"/*.toml)
if [[ ${#agent_files[@]} -eq 0 ]]; then
  echo "The GitHub archive contains no .codex/agents/*.toml files." >&2
  exit 1
fi

mkdir -p "$destination"

for agent_file in "${agent_files[@]}"; do
  agent_name="${agent_file##*/}"
  installed_path="${destination}/${agent_name}"
  cp "$agent_file" "$installed_path"
  echo "Installed ${installed_path}"
done
