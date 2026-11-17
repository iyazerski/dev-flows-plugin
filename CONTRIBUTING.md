# Contributing

Thanks for helping with Dev Flows. Skill ideas, bug reports and pull requests are all welcome.

## Report a bug or suggest a skill

[Open an issue](https://github.com/iyazerski/dev-flows-plugin/issues/new/choose) and pick a template. For questions, use [Discussions](https://github.com/iyazerski/dev-flows-plugin/discussions). For security problems, follow [SECURITY.md](SECURITY.md) instead.

## Write or change a skill

Each skill is a folder in `skills/` with a `SKILL.md` in the [Agent Skills](https://agentskills.io/specification) format:

- `name` matches the folder name, in lowercase words joined by hyphens.
- `description` says what the skill does and when to use it. Agents read only this line to decide whether to load the skill, so name the words a user would say.
- Keep the body short. Every line costs context in every session that loads it. Write steps the agent can follow, and leave out what it already knows.
- Point to other skills with `$skill-name`, as `harden` does with `$second-opinion`.
- Add `agents/openai.yaml` with a display name, a short description and a default prompt for the Codex skill picker.
- For best-practice skills, add evals in `evals/`: small tasks where the skill should change the result.

Don't edit `skills/rust-best-practices`. [`scripts/sync-skills.sh`](scripts/sync-skills.sh) mirrors it from [BeautifulRust](https://github.com/morganlinton/BeautifulRust), and a weekly workflow commits new upstream releases. Send changes upstream instead.

## Try your change

Install from your clone in the agent you use, then start a new session:

```sh
pi install /path/to/dev-flows-plugin                               # pi
npx skills add /path/to/dev-flows-plugin                           # most agents
claude --plugin-dir /path/to/dev-flows-plugin                      # Claude Code, for one session
```

If the published plugin is installed too, remove it first, or the agent sees each skill twice.

Before you open a pull request:

1. Install the hooks with [prek](https://github.com/j178/prek): `prek install`. They run `scripts/check.sh`, which checks the manifests and every skill's frontmatter.
2. Try the skill on a real task in at least one agent.
3. Keep pull requests small and focused on one change.

## Releases

Maintainers release by bumping `version` in `package.json`, `.claude-plugin/plugin.json` and `.codex-plugin/plugin.json` and merging to `main`. `scripts/check.sh` fails when the three differ. Users get the new version when they update the plugin.

By contributing, you agree that your work is released under the [MIT License](LICENSE). Please follow the [Code of Conduct](CODE_OF_CONDUCT.md).
