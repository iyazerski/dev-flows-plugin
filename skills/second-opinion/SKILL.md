---
name: second-opinion
description: Consult the other two LLMs for an independent second opinion on diffs, plans, or design approaches. Use when the user asks for a second opinion, external review, or sanity check from other AI models.
---

# Second Opinion

Get independent critiques on a proposed design, architecture, or git diff by consulting the other two model families through the `pi` harness.

The three supported model families are Claude, GPT, and Gemini. The host identifies its own model family, asks the other two via `pi`, then presents their feedback and a concise synthesis.

## Recursion Guard

Never invoke this skill if you are already answering a second opinion or review request from another agent. Only the host agent in the primary chat session calls peer models.

## Peer Models

All peers run in `pi` with these fixed models and thinking levels:

| Family     | Model              | Thinking |
| :--------- | :----------------- | :------- |
| **Claude** | `claude-opus-5-5`  | `medium` |
| **GPT**    | `gpt-6-sol`        | `high`   |
| **Gemini** | `gemini-3.8-flash` | `high`   |

Determine the host family from your own model (in pi, check `$PI_MODEL`): `claude-*` is Claude, `gpt-*` is GPT, `gemini-*` is Gemini. Never call your own family. Only invoke the other two.

### Availability

Some models may not be configured. Check each peer before running it. `pi --list-models` search is fuzzy, so match the model column exactly:

```bash
pi --list-models "$MODEL" | awk -v m="$MODEL" '$2 == m { found = 1 } END { exit !found }'
```

Skip unavailable peers and mention it in the report. If only one peer is available, use that single opinion. If none are available, tell the user and stop.

## Verified CLI Command

Run peers non-interactively with standard tool permissions so they can run tests and inspect code, but instruct them via prompt not to edit repository files. They use their installed skills for full project context.

Create a private temp directory to avoid collisions:

```bash
TMP_DIR=$(mktemp -d)
```

Run one peer (`$NAME` is `claude`, `gpt`, or `gemini`):

```bash
pi --model "$MODEL" --thinking "$THINKING" --exclude-tools edit,write --no-session -p < "$TMP_DIR/prompt.txt" > "$TMP_DIR/${NAME}_out.txt"
```

- `--model` / `--thinking`: Pin the peer model and reasoning level from the table above.
- `--exclude-tools edit,write`: Keeps `bash` and `read` active for running tests and inspections while preventing source file edits.
- `--no-session`: Runs ephemerally without persisting session files.

## Workflow

1. **Collect Context:**
   - **Scope Selection (Mixed Diffs):**
     If there are multiple unrelated uncommitted changes in the repository, do not review the entire diff. Isolate only the changes relevant to the current conversation:
     - **Specific files:** If the current feature is in a subset of files:
       ```bash
       git add -N <paths> && git diff HEAD -- <paths> > "$TMP_DIR/diff.patch" && git reset > /dev/null 2>&1
       ```
     - **Staged changes:** If the feature changes are already staged:
       ```bash
       git diff --cached > "$TMP_DIR/diff.patch"
       ```
     - **Entire working tree (single feature):**
       ```bash
       git add -N . && git diff HEAD > "$TMP_DIR/diff.patch" && git reset > /dev/null 2>&1
       ```
     - **Branch PR Diff:** determine base ref (`origin/main`, `origin/master`, or user-specified), then capture `git diff <base>...HEAD > "$TMP_DIR/diff.patch"`.
     - **Design / Approach:** write proposed architecture or plan to `$TMP_DIR/diff.patch`.

2. **Prepare Prompt:**
   Write the instructions first, then append the diff or approach text. Explicitly state the target feature scope and instruct the peer not to edit files or trigger a second opinion:

   ```bash
   cat <<'EOF' > "$TMP_DIR/prompt.txt"
   Your task is to provide a text review only. Do not edit, patch, or modify any repository files. Do not invoke the second-opinion skill. You may use bash to inspect code, run tests, or check dependencies if needed.

   Target feature / scope under review:
   <brief description of what was worked on in this session; ignore unrelated diffs>

   Critique the following content. Focus on bugs, edge cases, performance issues, or architectural flaws. Be concise and prioritize high-impact findings:

   EOF
   cat "$TMP_DIR/diff.patch" >> "$TMP_DIR/prompt.txt"
   ```

3. **Run Available Peers:**
   Run the command for each available peer model, in parallel when possible, and capture their responses. If one peer fails, report the error and proceed with the other.

4. **Clean Up:**
   Remove temporary directory:

   ```bash
   rm -rf "$TMP_DIR"
   ```

5. **Synthesize & Report:**
   - **Individual Findings:** Bullet-point summary of each peer model's key points. Note any skipped or failed peers.
   - **Consensus:** Items both peers agreed on (skip with a single peer).
   - **Disagreements / Unique Points:** Noteworthy issues caught by only one peer (skip with a single peer).
   - **Host Recommendation:** Your final takeaway or suggested changes.
