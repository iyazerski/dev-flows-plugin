# Dev Flows

Dev Flows is a plugin with concise development workflow skills for committing changes and drafting PRs, bundled with the [`lspyx`](https://github.com/iyazerski/lspyx) MCP server for Python semantic code navigation. The same `SKILL.md` files work with [Codex](#install-codex), [Claude Code](#install-claude-code), and [Pi](#install-pi).

## Skills

- `commit`: stage as needed and create a git commit.
- `draft-pr`: push the current branch and create a draft PR.

## MCP server

The plugin declares the [`lspyx`](https://github.com/iyazerski/lspyx) MCP server
in `.mcp.json`, which exposes the `lspyx_explore` tool for read-only semantic
navigation of Python workspaces.

Install the `lspyx` binary once so the MCP server can start:

```bash
curl -fsSL https://raw.githubusercontent.com/iyazerski/lspyx/main/install.sh | sh
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
