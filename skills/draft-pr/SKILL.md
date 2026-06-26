---
name: draft-pr
description: Create a draft pull request for the current branch. Use when the user asks Codex to open, create, publish, or draft a PR; mirrors the user's latest repo PR when possible, pushes the branch when needed, runs `gh pr create --draft`, and reports the created PR URL.
---

# Draft PR

Create a real draft PR for the current branch.

## Workflow

1. Confirm the current directory is a git repository and identify the current branch.
2. Choose the base ref specified by the user. If none is specified, use the first existing ref in this order:
   - `origin/main`
   - `origin/master`
3. Inspect the branch diff against the base:
   - `git diff <base_ref>...HEAD --name-status`
   - `git diff <base_ref>...HEAD --stat`
   - `git diff <base_ref>...HEAD`
4. Fetch the newest PR opened by the current user in this repo:
   - `gh pr list --state all --author "@me" --limit 1 --json number,title,body,url,createdAt`
5. Generate the PR title and body from the branch diff. Mirror the user's latest PR format and tone when one exists.
6. Push the current branch if the remote head does not already exist or is behind local `HEAD`.
7. Create the PR with `gh pr create --draft --base <base_branch> --head <current_branch> --title "<title>" --body-file <body_file>`.
8. Report the created draft PR URL, title, base, head, and any push performed.

Follow repo guidance for command prefixes and validation. Do not create a ready-for-review PR, merge, approve, request review, add labels, or push unrelated branches unless the latest user request explicitly asks.

## PR Title

- Keep it short and specific; aim to fit comfortably in GitHub UI.
- Prefer "what" over "how"; avoid vague titles.
- Use imperative mood.

## PR Body

Prefer the newest PR opened by the current user in this repo as the body format reference. If none exists, use the repository's existing PR template when present. Otherwise, include:
- Why: 1-2 sentences explaining the problem being solved or the feature being added.
- What: concise description of the new behaviour or functionality introduced.
