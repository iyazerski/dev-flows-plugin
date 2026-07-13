# Dev Flows

Dev Flows is a plugin with concise development workflow skills for committing changes and drafting PRs, bundled with the [`lspyx`](https://github.com/iyazerski/lspyx) MCP server for Python semantic code navigation. The skills work with both [Codex](#install-codex) and [Claude Code](#install-claude-code) — the same `SKILL.md` files back both.

## Skills

- `commit`: stage as needed and create a git commit.
- `draft-pr`: push the current branch and create a draft PR.

## Codex agents

The repository tracks four custom Codex agents under `.codex/agents/`:

- `code_explorer`: map code paths, reusable patterns, constraints, and tests before implementation.
- `task_researcher`: establish requirements from tasks, PRs, documentation, and conversations.
- `reviewer`: review an implemented diff for correctness, regressions, security, data, performance, and test gaps.
- `verifier`: run the relevant local checks and diagnose failures without changing source files.

Codex plugins do not currently install custom agent TOMLs. Install or refresh these agents separately from the GitHub repository:

```bash
curl -fsSL https://raw.githubusercontent.com/iyazerski/dev-flows-plugin/main/scripts/install_agents.sh | bash
```

The installer overwrites these repository-managed agent names in
`$CODEX_HOME/agents` (normally `~/.codex/agents`) and leaves other personal
agents unchanged. Start a new Codex task after installation so the agents are
loaded.

## MCP server

The plugin bundles the [`lspyx`](https://github.com/iyazerski/lspyx) MCP server
(declared in `.mcp.json`), which exposes the `lspyx_explore` tool for read-only
semantic navigation of Python workspaces — symbol search, file outlines, hover
details, definitions, and usages.

Install the `lspyx` binary once so the MCP server can start:

```bash
curl -fsSL https://raw.githubusercontent.com/iyazerski/lspyx/main/install.sh | sh
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

The skills then load as `commit` and `draft-pr`, and the `lspyx` MCP server registers its `lspyx_explore` tool.

## Update

- **Codex plugin:** run `/plugin marketplace update iyazerski`, then reinstall if prompted
- **Codex agents:** rerun the agent installer command above
- **Claude Code:** run `/plugin marketplace update iyazerski`, then reinstall if prompted.

## License

MIT. See [LICENSE](LICENSE).
