---
type: llm
focus: trace
weight: 1
---

Orders without a matching rate make the run fail with an error that names the missing day and currency pairs; they aren't silently dropped by an inner join or filled with a default rate
