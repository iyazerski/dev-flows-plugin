---
type: llm
focus: trace
weight: 1
---

Rows are validated or parsed in one place with real types (date, Decimal or float), and only rows that fail that parsing are skipped and counted. No broad except Exception or bare except swallows other errors
