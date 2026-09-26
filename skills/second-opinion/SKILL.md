---
name: second-opinion
description: Consult the other two agentic harnesses (codex, agy, pi) for an independent second opinion on diffs, plans, or design approaches. Use when the user asks for a second opinion, external review, or sanity check from other AI harnesses.
---

# Second Opinion

Get independent critiques on a proposed design, architecture, or git diff by consulting the other two agentic CLI harnesses.

The three supported harnesses are `codex`, `agy`, and `pi`. The current host harness asks the other two, then presents their feedback and a concise synthesis.

## Recursion Guard

Never invoke this skill if you are already answering a second opinion or review request from another agent. Only the host agent in the primary chat session calls peer harnesses.

## Harness Roles

Determine which two CLIs to call based on your current host harness:

| Current Host | CLIs to Call |
| :--- | :--- |
| **Codex** | `agy`, `pi` |
| **Pi** | `codex`, `agy` |
| **Antigravity (agy)** | `codex`, `pi` |

Never call your own CLI. Only invoke the other two.

## Verified CLI Commands

All harnesses use default models, default reasoning settings, and their installed skills for full project context. Run them non-interactively with standard tool permissions so they can run tests and inspect code, but instruct them via prompt not to edit repository files.

Create a private temp directory to avoid collisions:

```bash
TMP_DIR=$(mktemp -d)
```

### Codex
```bash
cat "$TMP_DIR/prompt.txt" | codex exec --ephemeral --skip-git-repo-check -o "$TMP_DIR/codex_out.txt" -
```
- `--ephemeral`: Avoids saving session history.
- `--skip-git-repo-check`: Allows running design reviews outside a git repo.
- `-o <file>`: Writes clean response text directly to file without metadata.

### AGY
```bash
agy --dangerously-skip-permissions -p "$(< "$TMP_DIR/prompt.txt")" > "$TMP_DIR/agy_out.txt"
```
- `-p`: Runs non-interactively and prints the response.
- `--dangerously-skip-permissions`: Auto-approves tool execution in headless mode.

### Pi
```bash
cat "$TMP_DIR/prompt.txt" | pi --exclude-tools edit,write --no-session -p > "$TMP_DIR/pi_out.txt"
```
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

3. **Run Both CLIs:**
   Run the commands for both peer harnesses and capture their responses. If one CLI fails or is missing, report the error and proceed with the other.

4. **Clean Up:**
   Remove temporary directory:
   ```bash
   rm -rf "$TMP_DIR"
   ```

5. **Synthesize & Report:**
   - **Individual Findings:** Bullet-point summary of each CLI's key points.
   - **Consensus:** Items both CLIs agreed on.
   - **Disagreements / Unique Points:** Noteworthy issues caught by only one CLI.
   - **Host Recommendation:** Your final takeaway or suggested changes.
