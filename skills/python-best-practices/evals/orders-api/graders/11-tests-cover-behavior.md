---
type: llm
focus: trace
weight: 1
---

Tests check that listing returns only the caller's orders, newest first, and honors the status filter and pagination, that cancelling a pending order persists the cancelled status, and that cancelling a non-pending order returns 409
