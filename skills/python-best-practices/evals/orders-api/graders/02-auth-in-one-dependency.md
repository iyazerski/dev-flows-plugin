---
type: llm
focus: trace
weight: 1
---

Bearer-token authentication is implemented once, in a FastAPI dependency (for example a CurrentUser Annotated alias or a router-level dependency). No route body reads the Authorization header or looks up the token itself
