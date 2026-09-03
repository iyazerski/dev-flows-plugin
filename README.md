# Dev Flows

Dev Flows is a plugin with concise development workflow skills for committing changes and drafting PRs, bundled with the [`lspyx`](https://github.com/iyazerski/lspyx) MCP server for Python semantic code navigation. The same `SKILL.md` files work with [Codex](#install-codex), [Claude Code](#install-claude-code), [Pi](#install-pi), and [Antigravity](#install-antigravity).

## Skills

- `commit`: stage as needed and create a git commit.
- `draft-pr`: push the current branch and create a draft PR.

## MCP server

The plugin declares the [`lspyx`](https://github.com/iyazerski/lspyx) MCP server
in `.mcp.json` and `mcp_config.json`, which exposes the `lspyx_explore` tool for read-only semantic
navigation of Python workspaces.

Install the `lspyx` binary once so the MCP server can start:

```bash
curl -fsSL https://raw.githubusercontent.com/iyazerski/lspyx/main/install.sh | sh
```

## Install (Antigravity)

### Global

1. Clone or symlink the repository into your global Antigravity plugins directory:

```bash
mkdir -p ~/.gemini/config/plugins
ln -s "$(pwd)" ~/.gemini/config/plugins/dev-flows
```

2. Register the `lspyx` MCP server in your global `~/.gemini/config/mcp_config.json`:

```json
{
  "mcpServers": {
    "lspyx": {
      "command": "lspyx",
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

2. Register the MCP server in `.agents/mcp_config.json`:

```json
{
  "mcpServers": {
    "lspyx": {
      "command": "lspyx",
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
