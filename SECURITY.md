# Security

Dev Flows is a set of instructions for AI coding agents. The skills tell your agent to run commands with your permissions: `git`, the GitHub CLI and pi. `draft-pr` pushes branches, and `harden` and `deslop` merge their own pull requests. Please report anything in a skill that could make an agent do something you didn't ask for, such as leaking secrets, pushing to the wrong place or skipping checks.

## Report a vulnerability

Report it privately through [GitHub's vulnerability reporting](https://github.com/iyazerski/dev-flows-plugin/security/advisories/new). Please don't open a public issue.

Include the skill, the agent and model you used, and what the agent did. You'll get an answer within a week.

## Supported versions

Only the latest version gets fixes. Update the plugin with your agent's update command, listed in the [README](README.md#install).

## Good to know

- The skills are plain Markdown. Read a `SKILL.md` before you install it if you want to check what it asks the agent to do.
- `rust-best-practices` is mirrored from [BeautifulRust](https://github.com/morganlinton/BeautifulRust) by a weekly workflow. The mirror pins an upstream release, and every update lands as a commit you can review.
