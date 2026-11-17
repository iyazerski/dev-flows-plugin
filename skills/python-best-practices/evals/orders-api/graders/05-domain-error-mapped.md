---
type: llm
focus: trace
weight: 1
---

Cancelling a non-pending order raises a domain exception from the service layer, and an exception handler or the route boundary maps it to 409. The service layer doesn't raise HTTPException or use status codes
