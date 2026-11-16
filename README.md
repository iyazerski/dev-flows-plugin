# Dev Flows

Dev Flows is a plugin with concise development workflow skills, bundled with [`lspyx`](https://github.com/iyazerski/lspyx) for Python semantic navigation, [`gopls`](https://go.dev/gopls/features/mcp) for Go semantic navigation, [`browse`](https://github.com/anomalyco/browse) for browser use in your Chrome, and [`cua-driver`](https://github.com/trycua/cua/tree/main/libs/cua-driver) for desktop app automation. The same `SKILL.md` files work with [Codex](#install-codex), [Claude Code](#install-claude-code), [Pi](#install-pi), and [Antigravity](#install-antigravity).

## Skills

- `commit`: stage as needed and create a git commit.
- `draft-pr`: push the current branch and create a draft PR.
- `second-opinion`: get a review from the other model family (Claude or GPT) via `pi` on diffs or designs.
- `harden`: review code with a peer model, fix the real findings on a branch, and merge a peer-reviewed PR.
- `deslop`: remove redundant comments, low-value tests, speculative safeguards, and ownership workarounds while keeping real production protections.
- `rust-best-practices`: write idiomatic, robust Rust. Mirrored from [BeautifulRust](https://github.com/morganlinton/BeautifulRust) (MIT) by `scripts/sync-skills.sh`. A weekly workflow commits new upstream releases and bumps the plugin's patch version. Do not edit it here.
- `go-best-practices`: Go 1.27+ rules that linters can't enforce: new standard library features and subtle pitfalls in interfaces, errors, concurrency, I/O, transactions, and tests. Ships `prek` and `golangci-lint` configs to copy into Go projects. Evals live in `skills/go-best-practices/evals/`.

## MCP servers

The plugin declares all MCP servers in `.mcp.json` and `mcp_config.json`. `lspyx` provides read-only semantic navigation for Python workspaces. `gopls mcp` does the same for Go (symbol search, references, package APIs, diagnostics) and can also rename symbols across the workspace.

`browse` drives your running Chrome through its extension, with your logins and tabs. Each harness starts a small `browse mcp` proxy, and all of them share one relay process that starts on demand. Agents work in their own background tabs, so concurrent agents don't interfere. Chrome shows its "started debugging" bar while browse is attached, but there's no approval prompt.

Install everything on macOS with one command:

```bash
curl -fsSL https://raw.githubusercontent.com/iyazerski/dev-flows-plugin/main/scripts/install.sh | sh
```

The script is safe to re-run. It:

- installs `lspyx`, `gopls` (only when Go is installed), `browse`, and `cua-driver` if they are missing, and skips the installed ones;
- installs `browse` without adding it to agent configs, since the plugin declares it, and pairs its Chrome extension.

Then run `cua-driver permissions grant` once to allow Accessibility and Screen Recording for `CuaDriver.app`.

browse updates itself. Its tools read and write files only in the temp folders (add more with `OPENCODE_BROWSER_FILE_ROOTS`). `browse status` shows the relay and the extension, and logs are in `~/.local/state/browse/logs`.

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

Start a new Codex task after installing so the skills and MCP server are loaded.

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
