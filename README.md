# Dev Flows

Dev Flows is a plugin with concise development workflow skills, bundled with [`lspyx`](https://github.com/iyazerski/lspyx) for Python semantic navigation and [`jevctl`](https://github.com/iyazerski/jevctl) for fast semantic evaluation. The same `SKILL.md` files work with [Codex](#install-codex), [Claude Code](#install-claude-code), [Pi](#install-pi), and [Antigravity](#install-antigravity).

## Skills

- `commit`: stage as needed and create a git commit.
- `draft-pr`: push the current branch and create a draft PR.
- `plan-lint`: remove speculative or unauthorized actions before substantial edits.
- `compare-options`: compare concrete implementation alternatives against verified constraints.
- `verify-claims`: check completion claims against actual evidence.

## MCP server

The plugin declares both MCP servers in `.mcp.json` and `mcp_config.json`. `lspyx` provides read-only semantic navigation for Python workspaces. `jevctl` provides one generic semantic `evaluate` tool used by the skills and available to agents directly.

Install the `lspyx` binary once so the MCP server can start:

```bash
curl -fsSL https://raw.githubusercontent.com/iyazerski/lspyx/main/install.sh | sh
```

Install `jevctl` and export `TYPESAFE_API_KEY` in the environment inherited by your agent host. The plugin never stores or injects the key:

```bash
curl -fsSL https://raw.githubusercontent.com/iyazerski/jevctl/main/install.sh | sh
```

## Install (Antigravity)

### Global

1. Clone or symlink the repository into your global Antigravity plugins directory:

```bash
mkdir -p ~/.gemini/config/plugins
ln -s "$(pwd)" ~/.gemini/config/plugins/dev-flows
```

2. Register the MCP servers in your global `~/.gemini/config/mcp_config.json`:

```json
{
  "mcpServers": {
    "lspyx": {
      "command": "lspyx",
      "args": ["mcp", "serve"]
    },
    "jevctl": {
      "command": "jevctl",
      "args": ["mcp", "serve"]
    }
  }
}
```

### Workspace

1. Place or symlink the plugin inside your project's `.agents/plugins/`:

```bash
mkdir -p .agents/plugins
ln -s /path/to/dev-flows-plugin .agents/plugins/dev-flows
```

2. Register the MCP servers in `.agents/mcp_config.json`:

```json
{
  "mcpServers": {
    "lspyx": {
      "command": "lspyx",
      "args": ["mcp", "serve"]
    },
    "jevctl": {
      "command": "jevctl",
      "args": ["mcp", "serve"]
    }
  }
}
```

## Install (Codex)

```bash
codex plugin marketplace add iyazerski/dev-flows-plugin
codex plugin add dev-flows@iyazerski
```

Start a new Codex task after installing so the skills and MCP server are loaded.

## Install (Claude Code)

```bash
claude plugin marketplace add iyazerski/dev-flows-plugin
claude plugin install dev-flows@iyazerski
```

Restart Claude Code or run `/reload-plugins` in the current session.

## Install (Pi)

```bash
pi install git:github.com/iyazerski/dev-flows-plugin
```

## Update

### Antigravity

Pull latest changes in the repository:

```bash
git pull
```

### Codex

```bash
codex plugin marketplace upgrade iyazerski
codex plugin add dev-flows@iyazerski
```

Start a new Codex task after updating.

### Claude Code

```bash
claude plugin update dev-flows@iyazerski
```

Restart Claude Code or run `/reload-plugins` inside the current session.

### Pi

```bash
pi update git:github.com/iyazerski/dev-flows-plugin
```

## License

MIT. See [LICENSE](LICENSE).
