---
type: llm
focus: trace
weight: 1
---

Loading an order and checking that it belongs to the caller happens in one dependency or one service function, not repeated in each route, and another user's order returns 404 rather than the order
