# Dev Flows

Dev Flows is a plugin with concise development workflow skills for reviewing code, committing changes, and drafting PRs. It works with both [Codex](#install-codex) and [Claude Code](#install-claude-code) — the same `SKILL.md` files back both.

## Skills

- `code-review-and-quality`: conduct multi-axis code review with quality gates.
- `commit`: stage as needed and create a git commit.
- `draft-pr`: push the current branch and create a draft PR.

## Vendored Skills

`code-review-and-quality` and its referenced checklists are vendored from
[addyosmani/agent-skills](https://github.com/addyosmani/agent-skills).
Vendor metadata lives under `vendor/<owner>/<repo>/`.

Refresh vendored files from the pinned upstream commits:

```bash
uv run python scripts/sync_vendors.py
```

## Install (Codex)

Add the marketplace, then install the plugin:

```
/plugin marketplace add iyazerski/dev-flows-plugin
/plugin install dev-flows@iyazerski
/reload-plugins
```

Start a new Codex thread after installing so the skills are loaded.

## Install (Claude Code)

Add the marketplace, then install the plugin:

```
/plugin marketplace add iyazerski/dev-flows-plugin
/plugin install dev-flows@iyazerski
```

The skills then load as `code-review-and-quality`, `commit`, and `draft-pr`.

## Update

- **Codex:** run `/plugin marketplace update iyazerski`, then reinstall if prompted
- **Claude Code:** run `/plugin marketplace update iyazerski`, then reinstall if prompted.

## License

MIT. See [LICENSE](LICENSE).
