---
type: llm
focus: trace
weight: 1
---

New code doesn't use getattr, hasattr, or isinstance on values whose types are already known, doesn't add `is not None` checks on non-optional values, and has no try/except that swallows errors or returns None, {}, or []
