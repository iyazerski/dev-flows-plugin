# Dev Flows

Dev Flows is a Codex plugin with concise development workflow skills for collecting task context, implementing scoped changes, reviewing code, committing, drafting PRs, and navigating Python code.

## Skills

- `collect-context`: gather a compact task context packet.
- `implement-task`: implement, validate, review, and fix a task until PR-ready.
- `review-changes`: perform detailed internal review of local changes.
- `review-pr`: review a teammate PR and produce GitHub-ready comments.
- `commit`: stage as needed and create a git commit.
- `draft-pr`: push the current branch and create a draft PR.
- `lspyx`: use `lspyx` for semantic Python navigation.

## Install

Install globally from GitHub:

```bash
npx codex-marketplace add iyazerski/dev-flows-plugin --plugin --global
```

Start a new Codex thread after installing so the skills are loaded.

## Update

Run the install command again after pulling or publishing changes.

## Licence

MIT. See [LICENSE](LICENSE).
