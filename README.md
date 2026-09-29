# Dev Flows

Dev Flows is a plugin with concise development workflow skills, bundled with [`lspyx`](https://github.com/iyazerski/lspyx) for Python semantic navigation, [`jevctl`](https://github.com/iyazerski/jevctl) for fast semantic evaluation, [`chrome-devtools-mcp`](https://github.com/ChromeDevTools/chrome-devtools-mcp) for browser debugging, and [`cua-driver`](https://github.com/trycua/cua/tree/main/libs/cua-driver) for desktop app automation. The same `SKILL.md` files work with [Codex](#install-codex), [Claude Code](#install-claude-code), [Pi](#install-pi), and [Antigravity](#install-antigravity).

## Skills

- `commit`: stage as needed and create a git commit.
- `draft-pr`: push the current branch and create a draft PR.
- `second-opinion`: consult other model families (Claude, GPT, Gemini) via `pi` for diff and design reviews.
- `semantic-eval`: fast semantic screening, coverage, and rule matching with `jevctl`.

## MCP servers

The plugin declares all MCP servers in `.mcp.json` and `mcp_config.json`. `lspyx` provides read-only semantic navigation for Python workspaces. `jevctl` provides one generic semantic `evaluate` tool used by the skills and available to agents directly.

`chrome-devtools-mcp` runs as one shared background service behind [`mcp-proxy`](https://github.com/TBXark/mcp-proxy), so every harness and thread uses the same instance instead of starting its own. It uses `--autoConnect`, so it attaches to your running Chrome (144+) instead of launching a new one. Page tools take a `pageId`, so concurrent agents can work in separate tabs.

Install everything on macOS with one command (Node.js required for `chrome-devtools-mcp`):

```bash
curl -fsSL https://raw.githubusercontent.com/iyazerski/dev-flows-plugin/main/scripts/install.sh | sh
```

The script is safe to re-run. It:

- installs `lspyx`, `jevctl`, `chrome-devtools-mcp`, `mcp-proxy`, and `cua-driver` if they are missing, and skips the installed ones;
- adds a `chrome-devtools` entry to `~/.config/mcp-proxy/config.json` and keeps any other servers there, so the same `mcp-proxy` can serve other projects;
- starts `mcp-proxy` as the launchd agent `com.github.tbxark.mcp-proxy` if it is not running, or restarts it only when the config changed.

Then:

- export `TYPESAFE_API_KEY` in the environment inherited by your agent host for `jevctl`. The plugin never stores or injects the key;
- enable remote debugging once in Chrome at `chrome://inspect/#remote-debugging`;
- run `cua-driver permissions grant` once to allow Accessibility and Screen Recording for `CuaDriver.app`.

The plugin connects to `http://127.0.0.1:8765/chrome-devtools/mcp`. `mcp-proxy` reconnects if `chrome-devtools-mcp` exits. File-writing tools can save anywhere under your home directory. Logs are in `~/Library/Logs/mcp-proxy.log`.

To update `chrome-devtools-mcp`, run `npm install -g chrome-devtools-mcp@latest` and restart the agent with `launchctl kickstart -k "gui/$(id -u)/com.github.tbxark.mcp-proxy"`.

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
