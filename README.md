# Dev Flows

Dev Flows is a plugin with concise development workflow skills, bundled with [`lspyx`](https://github.com/iyazerski/lspyx) for Python semantic navigation, [`jevctl`](https://github.com/iyazerski/jevctl) for fast semantic evaluation, and [`chrome-devtools-mcp`](https://github.com/ChromeDevTools/chrome-devtools-mcp) for browser debugging. The same `SKILL.md` files work with [Codex](#install-codex), [Claude Code](#install-claude-code), [Pi](#install-pi), and [Antigravity](#install-antigravity).

## Skills

- `commit`: stage as needed and create a git commit.
- `draft-pr`: push the current branch and create a draft PR.
- `second-opinion`: consult other agentic CLIs (`codex`, `agy`, `pi`) for diff and design reviews.
- `semantic-eval`: fast semantic screening, coverage, and rule matching with `jevctl`.

## MCP servers

The plugin declares all MCP servers in `.mcp.json` and `mcp_config.json`. `lspyx` provides read-only semantic navigation for Python workspaces. `jevctl` provides one generic semantic `evaluate` tool used by the skills and available to agents directly.

Install the `lspyx` binary once so the MCP server can start:

```bash
curl -fsSL https://raw.githubusercontent.com/iyazerski/lspyx/main/install.sh | sh
```

Install `jevctl` and export `TYPESAFE_API_KEY` in the environment inherited by your agent host. The plugin never stores or injects the key:

```bash
curl -fsSL https://raw.githubusercontent.com/iyazerski/jevctl/main/install.sh | sh
```

`chrome-devtools-mcp` runs via `npx` (Node.js required) with `--autoConnect`, so it attaches to your running Chrome (144+) instead of launching a new one. Enable remote debugging once in Chrome at `chrome://inspect/#remote-debugging`.

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
