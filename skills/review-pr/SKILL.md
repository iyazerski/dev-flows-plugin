---
name: review-pr
description: Review a teammate PR in an isolated temporary worktree, collect task context, run detailed task-scoped review, and convert actionable findings into concise GitHub-ready comments. Use for PR URLs, PR numbers, branches, or teammate PR review requests; prepares comments only and does not mutate remote state.
---

# Review PR

Review a PR without disturbing the user's working tree.

## Steps

1. Identify repo, PR number, base, head SHA, description, linked task, changed files, and diff.
2. Check out the PR head SHA in a fresh temporary worktree.
3. Collect a `Task Context Packet`.
4. Run `review-changes` against the PR diff and packet.
5. Convert actionable findings into concise GitHub-ready comments targeted to changed lines.
6. Clean up the temporary worktree and report any leftover path.

Do not post comments, approve, request changes, resolve threads, commit, or push unless explicitly asked.

## Output

Lead with GitHub-ready findings:

```md
### Finding N: <title>
Severity: P0/P1/P2/P3
Comment target: `<path>:<line>`

GitHub comment:
<friendly concise comment with problem, impact, and smallest useful change>

Why this matters:
<brief private evidence summary>
```

Also include PR reviewed, checks run, context reviewed, and temporary worktree status.
