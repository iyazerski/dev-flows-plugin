---
name: status-update
description: Generate a short, natural spoken status update for today's daily standup from work tickets, recent sessions in the current agent harness, and PR state. Use when the user asks for a standup update, daily status update, or summary of recent work for a call.
---

# Status Update

Generate a brief daily standup update optimized for speaking aloud on a team call.

## Workflow

1. **Set the window.** Always prepare the update for today's standup, covering work done since the last standup (usually the previous working day and today so far, or back to Friday on a Monday).
2. **Check the work board first.** Use whatever CLI, MCP, or browser tool is available for the work issue tracker (Jira, Asana, Linear, etc.). Inspect the user's board or sprint and recently updated items assigned to or reported by the user. This anchors the update and identifies work projects and ticket prefixes.
3. **Define work-only scope.** Separate work projects from personal projects and local meta/tooling work (editor, dotfile, or agent config tweaks) using the tracker, work-specific skills or instructions, git remotes, work email, or folder layout. Exclude personal and meta sessions even if they mention a work ticket ID in passing. If work vs. personal scope is still ambiguous on a mixed machine, ask once before scanning sessions.
4. **Inspect local sessions in the current harness.** Read session history for the harness you are currently running in (for example `~/.pi/agent/sessions`, `~/.claude/projects`, `~/.codex/sessions`, or the active harness's session store) for work projects only:
   - Filter entries by **message timestamps**, not session creation date. A single session often spans multiple days and tickets.
   - Capture work that is invisible on the board: completed tasks that vanished from the board (for example in Asana), unblocking work done while a ticket sat in "Blocked" or "In Progress" (such as infra or DevOps requests, investigations, or cross-repo fixes), and the concrete "what and why" behind each change.
5. **Verify live PR state.** When a PR or git CLI is available, check open or recently touched PRs referenced in the tickets or sessions (using work credentials without mutating global auth state). Reflect merges, approvals, or draft changes that happened after the last session or have not been synced to the board yet.
6. **Draft the update** following [Output Format](#output-format).

## Output Format

### Spoken update

- Write plain text ready to read aloud. Do not add headers (no Yesterday, Today, or Blockers) and do not split one piece of work across yesterday and today.
- Break the text into short paragraphs by logical item: for example, one paragraph per ticket, or for a single bugfix, one paragraph for the issue and one for the fix, plus a short paragraph for what's next if separate.
- Use short, simple sentences and everyday spoken English. Avoid long clauses (such as "which ..." or "even though ..."), robotic phrasing, and unnecessary jargon. Plain, casual wording is better than polished prose.
- Briefly explain **what** you worked on and **why** so teammates working on other areas can follow along, not just status labels.
- Include visible ticket IDs naturally when the tracker uses them (such as Jira keys). When there is no visible ID (such as Asana), use a short, natural task name instead of a long full title or service prefixes.

### Notes (optional)

- Below the spoken block, add brief bullet notes only when helpful, such as mismatches between live PR state and the board (a merged PR still in Review) or sources that could not be checked.
