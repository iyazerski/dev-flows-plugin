# Render one pi session file as Markdown: its active branch, oldest first.
#
#   jq -nrR --argjson tools false -f pi-session.jq SESSION.jsonl
#
# With `--argjson tools true`, assistant messages also list their tool calls, and failed tool results are shown.
# Lines that aren't valid JSON are skipped instead of failing the whole file.

def text: if type == "string" then . else map(select(.type == "text") | .text) | join("\n") end;
def cap($n): if length > $n then .[:$n] + "…" else . end;
def time: .[:16] | sub("T"; " ") + " UTC";

[inputs | fromjson? | select(type == "object")] as $all
| ($all | map(select(.type == "session")) | first // {}) as $head
| ($all | map(select(.type != "session" and .id != null))) as $entries
| ($entries | INDEX(.id)) as $by
# The last entry is the current leaf. Walking its parents skips branches left through /tree.
| [$entries | last // empty | recurse(if .parentId then $by[.parentId] else empty end) | select(. != null)]
| reverse
# A fork or clone starts with a copy of its parent's entries, which keep their original timestamps.
| map(select($head.parentSession == null or .timestamp >= $head.timestamp))
| . as $branch
| ($all | map(select(.type == "session_info") | .name) | last) as $name
| ([$branch[] | select(.message.role == "assistant") | "\(.message.provider)/\(.message.model)"] | unique) as $models
| [
    "# \($name // ($branch | map(select(.message.role == "user") | .message.content | text) | first // "Untitled") | gsub("\\s+"; " ") | cap(80))",
    "",
    "- Session: \($head.id)",
    "- Folder: \($head.cwd)",
    "- Started: \($head.timestamp | time)",
    "- Last activity: \($branch | last | .timestamp // $head.timestamp | time)",
    "- Models: \($models | join(", "))",
    (if $head.parentSession then "- Forked from: \($head.parentSession). Its history before the fork is left out." else empty end),
    (
      $branch[]
      | if .type == "message" then
          .message as $m
          | if $m.role == "user" then "\n## User (\(.timestamp | time))\n\n\($m.content | text)"
            elif $m.role == "assistant" then
              ($m.content | text) as $said
              | (if $tools then [$m.content[] | select(.type == "toolCall") | "- `\(.name)` \(.arguments | tojson | cap(300))"] else [] end) as $calls
              | if $said == "" and ($calls | length) == 0 then empty
                else "\n## Assistant (\(.timestamp | time))" + (if $said == "" then "" else "\n\n\($said)" end) + (if ($calls | length) > 0 then "\n\n" + ($calls | join("\n")) else "" end)
                end
            elif $m.role == "toolResult" and $tools and $m.isError then "\n- `\($m.toolName)` failed: \($m.content | text | gsub("\\s+"; " ") | cap(300))"
            elif $m.role == "bashExecution" then "\n## User ran `\($m.command | cap(300))` (exit \($m.exitCode // "none"))"
            else empty
            end
        elif .type == "compaction" then "\n## Compaction summary (\(.timestamp | time))\n\n\(.summary)"
        elif .type == "branch_summary" then "\n## Summary of a branch left through /tree (\(.timestamp | time))\n\n\(.summary)"
        elif .type == "custom_message" and .display then "\n## Extension message: \(.customType) (\(.timestamp | time))\n\n\(.content | text)"
        else empty
        end
    )
  ]
| join("\n")
