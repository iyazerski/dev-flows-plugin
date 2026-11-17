---
type: llm
focus: trace
weight: 1
---

Cancelling changes the status with a conditional update on the pending status (checking the affected row count) or after locking the row, not by reading the status, checking it in Python, and writing it back unguarded
