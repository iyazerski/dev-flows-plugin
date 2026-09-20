---
name: semantic-eval
description: Fast semantic evaluation with jevctl: screen candidates, check coverage, and match text against rules. Use when exact code cannot determine relevance or meaning; batch independent judgments over shared context.
---

# Semantic Evaluation

Use the `jevctl` MCP server's `evaluate` tool. If MCP is unavailable and the `jevctl` binary is installed, pass the same JSON to `jevctl evaluate` on stdin.

`jevctl` provides fast semantic judgments from TypeSafe's Jev model. Use it when code, linters, or regex cannot determine relevance, intent, coverage, or meaning.

## Core Rules

1. **Shared context:** Put all shared evidence, requirements, or reference material in `context`. Context can be a string, array, or structured JSON object.
2. **Batch questions:** Ask all independent judgments over the shared context in one call. Never make sequential calls for questions that share context.
3. **Choose the right question kind:**
   - `boolean`: Probability (0.0 to 1.0) that a condition holds. Provide `prompt`, and optionally `yes_when` / `no_when` to clarify boundaries.
   - `select`: Choose one option from a bounded set. Provide `prompt` and `options` map (`{"opt_id": "description"}`).
   - `scale`: Numeric position on ordered levels. Provide `prompt` and ordered `levels` array (`["low", "medium", "high"]`).
4. **Use compact output:** Default to compact output (`{"answers": {...}}`). Use `detail: "full"` only when probability distributions or confidence scores are needed for a consequential decision.
5. **Keep judgments advisory:** Results are advisory evidence. Deterministic tools (compilers, tests, linters, schemas, database state) are always authoritative.
6. **When NOT to use:** Do not use `jevctl` for arithmetic, code execution, syntax parsing, file finding, authorization decisions, or generating prose.

---

## Common Recipes

### 1. Candidate Screening & Filtering (Ranking & Triage)

Use when you have multiple candidate items (log snippets, search matches, code excerpts, query rows) and need to identify which ones are relevant to the user request.

**Example: screening log chunks for relevance to a crash**

```json
{
  "context": {
    "issue": "Pod crashed with OOMKilled or connection reset during deployment",
    "candidates": {
      "chunk_1": "2026-09-20 12:01:02 INFO Health check passed on port 8080",
      "chunk_2": "2026-09-20 12:01:05 WARN Connection reset by peer: postgres:5432",
      "chunk_3": "2026-09-20 12:01:08 DEBUG Worker pool idle: 4 threads"
    }
  },
  "questions": {
    "chunk_1_relevant": {
      "kind": "boolean",
      "prompt": "Is chunk_1 relevant to diagnosing the crash?",
      "yes_when": "Mentions errors, connection drops, memory, or failures related to the issue.",
      "no_when": "Routine heartbeat, informational log, or normal operation."
    },
    "chunk_2_relevant": {
      "kind": "boolean",
      "prompt": "Is chunk_2 relevant to diagnosing the crash?",
      "yes_when": "Mentions errors, connection drops, memory, or failures related to the issue.",
      "no_when": "Routine heartbeat, informational log, or normal operation."
    },
    "chunk_3_relevant": {
      "kind": "boolean",
      "prompt": "Is chunk_3 relevant to diagnosing the crash?",
      "yes_when": "Mentions errors, connection drops, memory, or failures related to the issue.",
      "no_when": "Routine heartbeat, informational log, or normal operation."
    }
  }
}
```

Filter candidate items based on probabilities (e.g. keep items with probability `>= 0.70`).

### 2. Coverage & Completeness Checking

Use when verifying that a draft handoff, PR summary, or proof query accounts for all user requirements and prior context without dropping essential constraints.

**Example: verifying a handoff covers all original user requirements**

```json
{
  "context": {
    "requirements": [
      "Target exactly two paused predecessors, no generic framework.",
      "Provide Snowflake proof queries that can be run on UI.",
      "Include root causes and fix proposals."
    ],
    "draft_handoff": "Investigated the data gap. Prepared Snowflake queries for the two predecessors and documented the root causes with fix recommendations."
  },
  "questions": {
    "scope_covered": {
      "kind": "boolean",
      "prompt": "Does the draft clearly reflect the exact two-predecessor scope without generic framework?",
      "yes_when": "Explicitly states or confirms the narrow scope.",
      "no_when": "Omits scope or suggests a broad framework."
    },
    "proof_queries_covered": {
      "kind": "boolean",
      "prompt": "Does the draft mention the Snowflake proof queries for UI validation?",
      "yes_when": "Mentions the queries and how to run them.",
      "no_when": "Omits proof queries."
    },
    "root_causes_covered": {
      "kind": "boolean",
      "prompt": "Does the draft include root causes and fixes?",
      "yes_when": "Addresses causes and fixes.",
      "no_when": "Omits causes or fixes."
    }
  }
}
```

If any question returns low probability, refine the draft before presenting it or handing off.

### 3. Semantic Rule & Style Matching

Use when checking draft communications (Slack messages, PR review comments, customer replies) or code hunks against specific guidelines.

**Example: checking a draft message against user style rules**

```json
{
  "context": {
    "draft": "Hi Joe, here is the PR for the migration. We tested both touchdown modes and verified data in Snowflake. Let me know if you want me to merge it.",
    "rules": [
      "Polite, casual, and direct.",
      "Short sentences and contractions.",
      "No corporate filler or idioms.",
      "No semicolons or em dashes."
    ]
  },
  "questions": {
    "matches_tone": {
      "kind": "boolean",
      "prompt": "Does the draft match the casual, direct, friendly peer tone?",
      "yes_when": "Natural, direct, peer-to-peer, concise.",
      "no_when": "Stiff, overly formal, bossy, or rambling."
    },
    "has_filler_or_forbidden_punctuation": {
      "kind": "boolean",
      "prompt": "Does the draft contain corporate filler, idioms, semicolons, or em dashes?",
      "yes_when": "Contains corporate buzzwords, idioms, semicolons, or em dashes.",
      "no_when": "Clean, simple sentences without forbidden elements."
    }
  }
}
```

### 4. Bounded Selection

Use when choosing the single best option from a discrete set of candidates based on semantic fit.

**Example: selecting the most relevant action or category**

```json
{
  "context": {
    "user_request": "Investigate why narrative-service failed to process identify events after the last deploy.",
    "options": {
      "inspect_logs": "Check Kubernetes pod logs and deployment events for crashes or exceptions.",
      "query_database": "Run Snowflake/Postgres queries to check ingested event counts.",
      "review_diff": "Examine the git diff of the latest deploy for breaking changes."
    }
  },
  "questions": {
    "first_step": {
      "kind": "select",
      "prompt": "Which initial action provides the most direct evidence for the failure?",
      "options": {
        "inspect_logs": "Check runtime pod logs and exceptions first.",
        "query_database": "Check database records first.",
        "review_diff": "Check recent code commits first."
      }
    }
  }
}
```
