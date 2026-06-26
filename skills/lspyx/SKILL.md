---
name: lspyx
description: "Use `lspyx` CLI for semantic Python code navigation"
---

# Lspyx

Use `lspyx` for Python semantic code navigation through LSP.

## Workflow

1. Start with `find-symbol <query>` when you only know a symbol name.
2. Run the narrow semantic command that answers the question.
3. Use `rg` when `lspyx` is unavailable, unsupported, or the task is not semantic navigation.

## Rules

- Omit `--workspace` by default when the current working directory or target file is already in the repo you want.
- Use `--limit N` to cap the number of results returned.
- Use `outline --depth N` for structure and `outline --full` only when the complete symbol tree matters.
- Keep queries narrow: resolve the symbol first, then inspect exact locations.
