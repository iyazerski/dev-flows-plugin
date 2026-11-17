<div align="center">

<img src="assets/logo.png" width="128" alt="Dev Flows logo">

# Dev Flows

**Development workflow skills for AI coding agents.**

Commits, draft PRs, hardening and cleanup passes,<br>
and Rust, Go and Python rules that linters can't enforce. One set of skills for Claude Code, Codex, pi, Cursor and 70+ other agents.

[![CI](https://github.com/iyazerski/dev-flows-plugin/actions/workflows/ci.yml/badge.svg)](https://github.com/iyazerski/dev-flows-plugin/actions/workflows/ci.yml)
[![Version](https://img.shields.io/github/package-json/v/iyazerski/dev-flows-plugin?color=10A37F)](package.json)
[![Agent Skills](https://img.shields.io/badge/agent-skills-black)](https://agentskills.io)
[![License: MIT](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Buy me a coffee](https://img.shields.io/badge/buy%20me%20a%20coffee-FFDD00?logo=buymeacoffee&logoColor=black)](https://buymeacoffee.com/iyazerski)

```sh
npx skills add iyazerski/dev-flows-plugin
```

</div>

## Why Dev Flows

Coding agents can commit, open PRs and review code, but each does it differently every time. Dev Flows gives them short, tested playbooks for the work you repeat every day.

- **Real results.** The skills end with a real commit, a real draft PR or a merged fix, not a list of suggestions.
- **A second pair of eyes.** `harden` gets a second opinion on its findings and its PR, with whatever your agent has for that: a subagent, a review tool or another model.
- **Your style, not a template.** `draft-pr` mirrors the title and body of your latest PR in the repo. `commit` writes short, focused messages from the staged diff.
- **Small context cost.** Each skill is about a page. The agent loads only the one it needs.
- **Rules that linters miss.** The Rust, Go and Python skills cover API design, errors, concurrency, app layering and new language features, and come with evals.
- **Works everywhere.** The skills follow the open [Agent Skills](https://agentskills.io) format, with native plugins for Claude Code, Codex, pi and Antigravity.

## Skills

| Skill | What it does | Try saying |
| --- | --- | --- |
| `commit` | Stages changes if nothing is staged, writes a concise message from the diff, and commits. | "Commit this." |
| `draft-pr` | Pushes the branch and opens a draft PR that matches your latest PR's style. | "Open a draft PR." |
| `harden` | Reviews the code, checks the findings with a second opinion, fixes the real findings on a branch, and merges a peer-reviewed PR. | "Harden this codebase." |
| `deslop` | Cuts needless comments, low-value tests, speculative defensive code and borrow-checker workarounds. | "De-slop the `api` package." |
| `rust-best-practices` | Idiomatic, robust Rust, mirrored weekly from [BeautifulRust](https://github.com/morganlinton/BeautifulRust). | "Review this crate's error types." |
| `go-best-practices` | Go 1.27+ features and pitfalls in interfaces, errors, concurrency, I/O, transactions and tests. Ships `prek` and `golangci-lint` configs. | "Refactor this Go service." |
| `python-best-practices` | Python 3.14+ features and the slop agents add: defensive checks, swallowed errors, fat FastAPI routes, slow dataframe code. Ships `prek`, `ruff` and `ty` configs. | "Add an endpoint to this FastAPI app." |

`harden` reports its findings and waits for your approval before it changes code. `harden` and `deslop` both work on a branch and merge through a PR.

## Install

### Any agent

The [skills CLI](https://github.com/vercel-labs/skills) installs the skills into Cursor, Gemini CLI, GitHub Copilot, OpenCode and 70+ other agents. It asks which agents and skills you want:

```sh
npx skills add iyazerski/dev-flows-plugin
```

### Native plugins

<details>
<summary><b>Claude Code</b></summary>

```sh
claude plugin marketplace add iyazerski/dev-flows-plugin
claude plugin install dev-flows@iyazerski
```

Update with `claude plugin update dev-flows@iyazerski`, then restart Claude Code or run `/reload-plugins`.

</details>
<details>
<summary><b>Codex</b></summary>

```sh
codex plugin marketplace add iyazerski/dev-flows-plugin
codex plugin add dev-flows@iyazerski
```

Run the same `add` command to update. Start a new task afterwards, so the skills load.

</details>
<details>
<summary><b>pi</b></summary>

```sh
pi install git:github.com/iyazerski/dev-flows-plugin
```

Update with `pi update git:github.com/iyazerski/dev-flows-plugin`.

</details>
<details>
<summary><b>Antigravity</b></summary>

Clone the repository and link it into your global Antigravity plugins folder:

```sh
git clone https://github.com/iyazerski/dev-flows-plugin.git
mkdir -p ~/.gemini/config/plugins
ln -s "$PWD/dev-flows-plugin" ~/.gemini/config/plugins/dev-flows
```

Update with `git pull` in the clone.

</details>

### Requirements

| Skill | Needs |
| --- | --- |
| `commit` | git |
| `draft-pr`, `deslop` | git and the [GitHub CLI](https://cli.github.com), logged in |
| `harden` | everything above |
| `rust-best-practices`, `go-best-practices`, `python-best-practices` | nothing |

## FAQ

<details>
<summary><b>Do the skills push or merge without asking?</b></summary>

`commit` never pushes. `draft-pr` pushes your branch and opens a draft, but never marks it ready, merges or requests reviews unless you ask. `harden` reports its findings and waits for your approval before it fixes anything. `deslop` makes its cuts right away. Both work on a new branch and merge their own PR once CI passes, so use them in repos where that's fine.

</details>
<details>
<summary><b>Can I install only some skills?</b></summary>

Yes. Pick them in the skills CLI prompt, or pass `--skill`, for example `npx skills add iyazerski/dev-flows-plugin --skill commit --skill draft-pr`.

</details>

## Contributing

Ideas for new skills, bug reports and pull requests are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE) © Ihar Yazerski. `rust-best-practices` comes from [BeautifulRust](https://github.com/morganlinton/BeautifulRust) under its [MIT license](skills/rust-best-practices/LICENSE).

Dev Flows isn't affiliated with or endorsed by Anthropic, OpenAI, Google, Cursor or the makers of pi. All trademarks belong to their owners.
