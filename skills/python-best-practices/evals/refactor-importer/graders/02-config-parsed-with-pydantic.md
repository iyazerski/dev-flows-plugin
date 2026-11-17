---
type: llm
focus: trace
weight: 1
---

The config file is parsed into a Pydantic model (model_validate_json or similar), with defaults declared on the model, instead of .get chains on a dict. A missing or invalid config raises an error instead of returning {}
