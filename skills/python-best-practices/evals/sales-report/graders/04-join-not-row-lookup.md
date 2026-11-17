---
type: llm
focus: trace
weight: 1
---

USD conversion uses a join between orders and rates on day and currency, not a per-row dictionary lookup, apply, iterrows, map_elements, or a Python loop
