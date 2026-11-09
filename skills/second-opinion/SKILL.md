---
name: second-opinion
description: Get an independent review of a diff, plan, or design from the other model family (Claude or GPT) via pi. Use when the user asks for a second opinion or an outside review.
---

# Second Opinion

Never use this skill while you are answering another agent's review request.

Ask GPT if you're Claude (check `$PI_MODEL` in pi), otherwise ask Claude:

| Peer   | Model             | Thinking |
| :----- | :---------------- | :------- |
| Claude | `claude-opus-5-5` | `medium` |
| GPT    | `gpt-6.1-sol`     | `high`   |

Check that the peer is available, matching the model column exactly since the search is fuzzy. If it isn't, tell the user and stop:

```bash
pi --list-models "$MODEL" | awk -v m="$MODEL" '$2 == m { found = 1 } END { exit !found }'
```

Write a prompt to a temp file and run the peer read-only:

```bash
pi --model "$MODEL" --thinking "$THINKING" --exclude-tools edit,write --no-session -p < "$TMP/prompt.txt" > "$TMP/out.txt"
```

In the prompt, say what's in scope, ask for a concise review of bugs, edge cases, performance, and design flaws, and tell the peer not to edit files or ask for a second opinion. Then add the content: only the diff for the work in this conversation, or the plan or design.

Report the peer's main points, which ones you agree with after checking the code, and what you recommend.
