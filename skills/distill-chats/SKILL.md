---
name: distill-chats
description: Distill recent agent chats for a project into durable project knowledge. Use when the user asks to analyze, review, or learn from past chats or sessions and extract gotchas, findings, corrections, or workarounds into AGENTS.md, skills, rules, or wiki pages; renders pi session files to Markdown with `jq`, extracts and verifies candidate findings, and proposes targeted documentation changes.
---

# Distill Chats

Turn recent agent chats for a project into short, verified additions to the project's agent knowledge. The goal is that future agents stop repeating the same mistakes and rediscovering the same workarounds.

The chats are [pi](https://github.com/earendil-works/pi) sessions. That includes pi chats started from Zeron.

## Scope

Settle these before reading. Use the user's values when given, otherwise the defaults:

- **Project:** the current repository, `git rev-parse --show-toplevel`. Sessions started in its subfolders count too.
- **Window:** the last 30 days, by each session's last activity.
- **Targets:** the files that hold agent knowledge for this project, such as `AGENTS.md`, `CLAUDE.md`, `.claude/rules/`, project skills, or wiki pages. Discover them in the repo and in skills the project already uses. If none exist, propose `AGENTS.md`.

## Read Sessions

Pi stores each session as a JSONL file at `~/.pi/agent/sessions/--<cwd with / replaced by ->--/<start time>_<session id>.jsonl`, unless `PI_CODING_AGENT_SESSION_DIR` or the `sessionDir` setting in `~/.pi/agent/settings.json` moves it. The first line is a header with the session's `cwd`. `docs/session-format.md` in the pi package describes every entry type.

List the sessions of the project that were active in the window, then render each one to Markdown with [`pi-session.jq`](pi-session.jq). Set `FILTER` to that file's absolute path: it sits next to this `SKILL.md`. Leave out tool calls for the first pass:

```bash
FILTER=/path/to/distill-chats/pi-session.jq
TMP_DIR=$(mktemp -d)
ROOT=$(git rev-parse --show-toplevel)
SESSIONS=${PI_CODING_AGENT_SESSION_DIR:-$HOME/.pi/agent/sessions}
fd -e jsonl --changed-within 30d . "$SESSIONS" | while IFS= read -r f; do
  [ "$f" = "${PI_SESSION_FILE:-}" ] && continue
  head -n 1 "$f" | jq -e --arg root "$ROOT" '.cwd == $root or (.cwd | startswith($root + "/"))' >/dev/null || continue
  jq -nrR --argjson tools false -f "$FILTER" "$f" > "$TMP_DIR/$(basename "$f" .jsonl).md"
done
```

Pass absolute paths to `jq`: session folder names start with `--`, so a relative path parses as an option. The loop skips the session running this skill (`PI_SESSION_FILE`).

Files are named `<start time>_<session id>.md`, so they sort oldest first. Each starts with a metadata list (session id, folder, time range, models), followed by one heading per message:

- `## User (<time>)`: written by the user. This is the main source of corrections and preferences. A message that starts with `[Message from Zeron chat <title> (<id>)…]` was sent in by another agent chat, such as a sub-agent or a reviewer. Treat it as agent output, not user feedback.
- `## Assistant (<time>)`: the agent's answer. Messages with only tool calls are left out.
- ``## User ran `<command>` ``: a shell command the user ran with `!`.
- `## Compaction summary` and `## Summary of a branch left through /tree`: summaries pi wrote of earlier or abandoned work.

The file shows the session's current branch. A forked or cloned session has a `Forked from` line, and its copied history is left out, so read the parent session when the fork needs that context. When a candidate needs the exact commands the agent ran, or the errors it hit, render that session again with `--argjson tools true`.

Skip sessions with no real work, for example a single request with no answer.

## Workflow

1. **Read the targets first.** Know what is already documented, so you only extract what is new or what contradicts the docs.
2. **Extract candidates, one chat at a time.** List the files with their sizes, then read each chat fully. When the harness supports sub-agents, delegate batches of chats and ask each for candidates in the format below. Keep only candidates in context, not transcripts.
3. **Merge.** Combine duplicates across chats, and keep the evidence from each chat. A finding seen in several chats has a stronger case.
4. **Verify against the current state.** Chats can be weeks old, and the code may have changed since. Check each candidate against the repo, its config, CLI `--help` output, or cheap read-only queries. Drop candidates that are stale, already fixed in code, or not confirmable, and say why.
5. **Remove sensitive data.** Never carry secrets, tokens, credentials, personal data, or customer data into the proposed text. Replace them with placeholders or describe where to get them.
6. **Route each finding** to the most specific target that fits, matching that file's existing structure and style:
   - Repo-wide rules and conventions: `AGENTS.md` or its equivalent.
   - A narrow, repeatable workflow: a project skill.
   - Background and longer explanations: wiki or docs.
   - Something that belongs in code, such as a missing check or a misleading name: report it as a code change suggestion, not a doc entry.
7. **Propose, then apply.** Present the findings for approval (see [Report](#report)). Edit target files only after the user approves, unless the latest user request already asked to apply the changes. Then show the diff.
8. **Clean up:** `rm -rf "$TMP_DIR"`.

## What Counts as a Finding

Look for:

- **Corrections:** the user rejects an approach or tells the agent to do something differently ("no, use X", "don't touch Y").
- **Dead ends:** the agent tried something that failed, then found what works.
- **Repeated rediscovery:** several chats spend effort finding the same command, path, connection, or fact.
- **Surprises:** tool, environment, data, or process behavior that differs from what a reasonable agent would assume.
- **Stated preferences:** how the user wants explanations, reviews, commits, or rollouts done in this project.

Skip:

- Details of a single task that will not come up again, such as ticket status, one-off decisions, or temporary state.
- Anything an agent can learn quickly from the code or the docs.
- General engineering advice that is not specific to this project.
- Things already documented, unless the docs are wrong or were ignored in a way that suggests they need to be clearer.

## Candidate Format

For each candidate, record:

- **Finding:** one or two imperative sentences, written as it would appear in the target.
- **Evidence:** chat id prefixes and timestamps, with a short quote or summary of what happened.
- **Frequency:** how many chats it showed up in.
- **Target:** the file and section where it belongs.

## Report

Present a short list, strongest findings first. For each one, give the proposed text, the target, the evidence (chat ids), and how it was verified. Then list the dropped candidates in one line each with the reason (stale, one-off, already documented, unverifiable). Keep the proposed entries short: a future agent reads them on every task, so every line has a cost.
