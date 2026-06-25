---
name: draft-pr
description: Create a draft pull request for the current branch. Use when the user asks Codex to open, create, publish, or draft a PR; generates a title and body from the branch diff against main/master, pushes the branch when needed, runs `gh pr create --draft`, and reports the created PR URL.
---

# Draft PR

Create an actual draft PR. Do not only draft or return PR text.

## Workflow

1. Confirm the current directory is a git repository and identify the current branch.
2. If not specified by user, determine the base ref in this order:
   - `origin/main`
   - `origin/master`
3. Inspect only the branch diff against the base:
   - `git diff <base_ref>...HEAD --name-status`
   - `git diff <base_ref>...HEAD --stat`
   - `git diff <base_ref>...HEAD`
4. Generate PR title and body from that diff.
5. Push the current branch if the remote head does not already exist or is behind local `HEAD`.
6. Create the PR with `gh pr create --draft --base <base_branch> --head <current_branch> --title "<title>" --body-file <body_file>`.
7. Report the created draft PR URL, title, base, head, and any push performed.

Follow repo guidance for required command prefixes and validation. Do not create a ready-for-review PR, merge, approve, request review, add labels, or push unrelated branches unless the latest user request explicitly asks.

## PR Title

- Keep it short and specific; aim to fit comfortably in GitHub UI.
- Prefer "what" over "how"; avoid vague titles.
- Use imperative mood.

## PR Body

Use the repository's existing PR template when present. Otherwise, it should contain these sections:
- Why: 1-2 sentences explaining the problem being solved or the feature beind added.
- What: concise description of the new behaviour or functionality introduced.
