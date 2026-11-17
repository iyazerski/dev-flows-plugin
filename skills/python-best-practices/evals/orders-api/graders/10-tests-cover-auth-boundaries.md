---
type: llm
focus: trace
weight: 1
---

Tests call the HTTP API (TestClient or httpx2.ASGITransport) against an isolated test database, and include a request without credentials (401) and a request for another user's order (404)
