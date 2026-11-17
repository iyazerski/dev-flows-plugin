---
type: llm
focus: trace
weight: 1
---

Route functions contain no SQLAlchemy queries, session.commit calls, or business rules. They call service or repository functions and return the result
