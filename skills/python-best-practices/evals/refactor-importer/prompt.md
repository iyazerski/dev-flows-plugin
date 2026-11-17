---
tags: [python-best-practices]
max_turns: 30
timeout_seconds: 900
allowed_tools: [Read, Glob, Grep, Skill, Write, Edit, Bash]
---

Here is our ledger importer. It works, but it's hard to change and reviewers keep flagging it. Can you refactor it into clean, idiomatic Python? Keep the behavior the test checks, and update the test if a signature or the result type changes. You can change dependencies. Write a short list of what you changed and why to CHANGES.md in the current directory. uv and Python 3.14 are installed.

Input files: pyproject.toml, ledger/importer.py, tests/test_importer.py
