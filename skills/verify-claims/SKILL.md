---
name: verify-claims
description: Check material completion claims against actual diffs, tests, command output, or live evidence before reporting success. Use for non-obvious final claims; skip routine statements directly established by the immediately visible result.
---

# Verify Claims

First gather the authoritative evidence. Run required tests and inspect the actual diff or external state before using this skill. The semantic check does not replace those steps.

Use the `jevctl` MCP server's `evaluate` tool. If MCP is unavailable and the `jevctl` binary is installed, pass the same JSON to `jevctl evaluate` on stdin.

Put concise numbered evidence and the proposed completion claims in one context. Ask one independent `select` question per claim with these options:

- `supports`: the evidence directly supports the claim;
- `contradicts`: the evidence conflicts with the claim;
- `says_nothing`: the evidence does not establish it.

Batch the questions and use compact output. Remove or qualify contradicted and unsupported claims, or gather better evidence and evaluate again. Never infer that a passing suite covers behavior absent from its tests. Deterministic test results, repository rules, and actual observed state remain authoritative.
