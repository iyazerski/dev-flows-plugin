---
type: llm
focus: trace
weight: 1
---

No async def route or dependency calls the synchronous SQLAlchemy session; database routes and dependencies are plain def functions, or the session is async
