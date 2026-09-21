---
name: semantic-eval
description: Fast, cheap semantic decisions and typed judgments. Use when needing to classify, screen, rank, or verify text, candidates, or draft content.
---

# Semantic Evaluation

Call the `jevctl` MCP server's `evaluate` tool.

`jevctl` connects to TypeSafe's Jev: a fast (~100ms) System One model. It turns natural language and application state into typed decisions and calibrated probabilities (`boolean`, `select`, `scale`) rather than generating prose.

Use `evaluate` to avoid expensive, slow reasoning loops whenever you need a structured semantic decision.

## When to Use

Use whenever you need a fast semantic judgment over text or data:

- **Screening & Ranking:** Filter or score multiple candidates (logs, search results, code excerpts, query rows) in one call.
- **Coverage & Verification:** Verify that a summary, handoff, or plan covers all required constraints or evidence.
- **Rule & Style Matching:** Check draft messages, PR comments, or diffs against subjective guidelines (tone, policy, conciseness).
- **Classification & Routing:** Map an error, request, or state to a fixed set of categories or next actions.

Deterministic tools (tests, compilers, linters, schemas, database queries) are always authoritative. Never use `evaluate` for arithmetic, code execution, syntax parsing, or generating text.

## How to Call

1. **Shared context:** Put shared text, requirements, or evidence in `context` (string, array, or object).
2. **Batch questions:** Ask all independent questions over that context in one call. They run in parallel.
3. **Choose the primitive:**
   - `boolean`: Returns probability (0.0 to 1.0). Use `yes_when` / `no_when` to set boundaries.
   - `select`: Picks one key from the supplied `options` map.
   - `scale`: Returns a continuous position across ordered `levels` (e.g. `["low", "medium", "high"]`).
4. **Default to compact:** Returns scalar answers: `{"answers": {"q1": 0.95, "q2": "opt_a"}}`.

## Examples

### 1. Screening candidates & checking criteria

```json
{
  "context": {
    "goal": "Identify root cause of connection timeouts",
    "items": {
      "log_a": "Health check 200 OK on port 8080",
      "log_b": "Connection reset by peer: postgres:5432 after 30s",
      "log_c": "Worker pool idle: 4 threads"
    }
  },
  "questions": {
    "log_b_relevant": {
      "kind": "boolean",
      "prompt": "Does log_b indicate the connection timeout cause?",
      "yes_when": "Mentions database connection drops or network timeouts."
    },
    "severity": {
      "kind": "scale",
      "prompt": "Rate the failure severity",
      "levels": ["minor", "degraded", "outage"]
    }
  }
}
```

### 2. Selecting an option & verifying coverage

```json
{
  "context": {
    "requirements": ["Exact two-predecessor migration", "Snowflake validation query"],
    "draft": "Prepared Snowflake query for the two predecessors to validate data."
  },
  "questions": {
    "covers_requirements": {
      "kind": "boolean",
      "prompt": "Does the draft cover all requirements without expanding scope?"
    },
    "next_action": {
      "kind": "select",
      "prompt": "What is the best next step?",
      "options": {
        "run_query": "Execute query against Snowflake to verify output.",
        "ask_user": "Ask user for missing credentials or scope clarification."
      }
    }
  }
}
```
