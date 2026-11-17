---
tags: [python-best-practices]
max_turns: 40
timeout_seconds: 1200
allowed_tools: [Read, Glob, Grep, Skill, Write, Edit, Bash]
---

This is our orders service. Please add three endpoints for API clients:

- `GET /orders` lists the caller's orders, newest first. Optional `status` filter, and `limit`/`offset` pagination.
- `GET /orders/{order_id}` returns one of the caller's orders.
- `POST /orders/{order_id}/cancel` cancels a pending order. Orders in any other status can't be cancelled.

Clients authenticate with `Authorization: Bearer <token>`, matched against `users.api_token`. A user must never see or touch another user's orders. Add tests next to the existing ones. uv and Python 3.14 are installed.

Input files: pyproject.toml, app/, tests/
