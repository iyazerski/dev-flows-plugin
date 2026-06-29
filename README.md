# Dev Flows

Dev Flows is a Codex plugin with concise development workflow skills for reviewing code, committing changes, and drafting PRs.

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

## Install

Install globally from GitHub:

```bash
npx codex-marketplace add iyazerski/dev-flows-plugin --plugin --global
```

Start a new Codex thread after installing so the skills are loaded.

## Update

Run the install command again after pulling or publishing changes.

## License

MIT. See [LICENSE](LICENSE).
