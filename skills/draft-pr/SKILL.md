---
name: draft-pr
description: Create a draft pull request for the current branch. Use when the user asks to open, create, publish, or draft a PR; mirrors the user's latest repo PR when possible, pushes the branch when needed, runs `gh pr create --draft`, and reports the created PR URL.
---

# Draft PR

Create a real draft PR for the current branch.

## Workflow

1. Confirm the current directory is a git repository and identify the current branch.
2. Choose the base branch. Use the one the user specified. Otherwise, infer the branch the current branch was created from using the conversation context. If the base is ambiguous, stop and ask the user which base branch to use.
3. Inspect the branch diff against the base:
   - `git diff origin/<base_branch>...HEAD --name-status`
   - `git diff origin/<base_branch>...HEAD --stat`
   - `git diff origin/<base_branch>...HEAD`
4. Fetch the newest PR opened by the current user in this repo:
   - `gh pr list --state all --author "@me" --limit 1 --json number,title,body,url,createdAt`
5. Generate the PR title and body from the branch diff. When a latest PR exists, mirror its title style, body structure, scope, and tone as described in [PR Body](#pr-body).
6. Push the current branch if the remote head does not already exist or is behind local `HEAD`.
7. Create the PR with `gh pr create --draft --base <base_branch> --head <current_branch> --title "<title>" --body-file <body_file>`.
8. Report the created draft PR URL, title, base, head, and any push performed.

Follow repo guidance for command prefixes and validation. Do not create a ready-for-review PR, merge, approve, request review, add labels, or push unrelated branches unless the latest user request explicitly asks.

## PR Title

- Keep it short and specific; aim to fit comfortably in GitHub UI.
- Prefer "what" over "how"; avoid vague titles.
- Use imperative mood.

## PR Body

Prefer the newest PR opened by the current user in this repo as the reference. Treat it as a template to match closely, not loose inspiration:
- Structure: use the same sections and headings, in the same order, with the same Markdown elements (prose, bullets, checklists, code blocks, links). Do not add sections it lacks, such as "Testing" or "Files changed". If a reference section does not apply to this change, drop it instead of filling it with filler.
- Scope: match its length and level of detail. If it summarizes the change in a few high-level bullets, do the same instead of listing every file or function. If it goes into detail, go into similar detail.
- Title: follow its title conventions, such as ticket prefixes, conventional-commit types, or capitalization.
- Tone: match its voice and wording style.
- Content: write it from the current diff only. Never copy facts, links, or ticket IDs from the reference unless they also apply to this change.

If no reference PR exists, use the repository's existing PR template when present. Otherwise, include:
- Why: 1-2 sentences explaining the problem being solved or the feature being added.
- What: concise description of the new behaviour or functionality introduced.
