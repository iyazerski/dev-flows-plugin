---
type: llm
focus: trace
weight: 1
---

OrderService no longer stores a context.Context; ProcessAll (and any other method that calls out) takes ctx context.Context as its first parameter
