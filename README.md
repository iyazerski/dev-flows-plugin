# Dev Flows

Dev Flows is a plugin with concise development workflow skills. The same `SKILL.md` files work with [Codex](#install-codex), [Claude Code](#install-claude-code), [Pi](#install-pi), and [Antigravity](#install-antigravity).

## Skills

- `commit`: stage as needed and create a git commit.
- `draft-pr`: push the current branch and create a draft PR.
- `second-opinion`: get a review from the other model family (Claude or GPT) via `pi` on diffs or designs.
- `harden`: review code with a peer model, fix the real findings on a branch, and merge a peer-reviewed PR.
- `deslop`: remove redundant comments, low-value tests, speculative safeguards, and ownership workarounds while keeping real production protections.
- `rust-best-practices`: write idiomatic, robust Rust. Mirrored from [BeautifulRust](https://github.com/morganlinton/BeautifulRust) (MIT) by `scripts/sync-skills.sh`. A weekly workflow commits new upstream releases and bumps the plugin's patch version. Do not edit it here.
- `go-best-practices`: Go 1.27+ rules that linters can't enforce: new standard library features and subtle pitfalls in interfaces, errors, concurrency, I/O, transactions, and tests. Ships `prek` and `golangci-lint` configs to copy into Go projects. Evals live in `skills/go-best-practices/evals/`.

## Install

### Antigravity

Clone or symlink the repository into your global Antigravity plugins directory:

```bash
mkdir -p ~/.gemini/config/plugins
ln -s "$(pwd)" ~/.gemini/config/plugins/dev-flows
```

### Codex

```bash
codex plugin marketplace add iyazerski/dev-flows-plugin
codex plugin add dev-flows@iyazerski  # use the same command for updates
```

Start a new Codex task after installing so the skills are loaded.

### Claude Code

```bash
claude plugin marketplace add iyazerski/dev-flows-plugin
claude plugin install dev-flows@iyazerski
```

To update the plugin, run:

```bash
claude plugin update dev-flows@iyazerski
```

Restart Claude Code or run `/reload-plugins` in the current session.

### Pi

```bash
pi install git:github.com/iyazerski/dev-flows-plugin
```

To update the plugin, run:

```bash
pi update git:github.com/iyazerski/dev-flows-plugin
```

## License

MIT. See [LICENSE](LICENSE).
