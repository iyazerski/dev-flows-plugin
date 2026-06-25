---
name: commit
description: Create a git commit from the current repository changes. Use when the user asks Codex to commit, save changes in git, or create a commit; stages all changes only when nothing is already staged, generates a concise commit message from the staged diff, runs the commit command, and reports the created commit.
---

# Commit

Create an actual git commit. Do not only draft or return a commit message.

## Workflow

1. Inspect staged changes with:
   - `git diff --staged --name-status`
   - `git diff --staged --stat`
   - `git diff --staged`
2. If nothing is staged, run `git add -A`, then re-run the staged diff commands.
3. Generate the commit message from the staged diff only. Do not use unstaged diffs unless step 2 staged them.
4. Run the repository's required pre-commit validation before committing when repo guidance requires it.
5. Create the commit with `git commit -m "<subject>" -m "<body>"`.
6. Report the commit hash, subject, and any validation that ran.

Do not push, create a branch, amend, or use `--no-verify` unless the latest user request explicitly asks.

## Message Format

- Subject: imperative mood, capitalised, 72 characters or fewer, no trailing full stop.
- Body: 0-5 bullet lines starting with `- `.
- Each bullet describes one concrete staged change and why it matters.
- Keep body lines 72 characters or fewer.
