---
name: python-best-practices
description: Python rules that ruff and ty can't enforce, including FastAPI, SQLAlchemy, and dataframe code. Use when writing, reviewing, refactoring, or debugging Python code.
---

# Python best practices

This file assumes Python 3.14 or newer, uv, and repo hooks that run `ruff check`,
`ruff format`, `ty check`, and `pytest`. It lists only what those tools don't catch. If
the repo has no Python hooks, suggest that the user adopt `assets/pre-commit-config.yaml`
and the settings in `assets/pyproject.toml`.

Read the matching reference before you change code that uses:

- FastAPI: `references/fastapi.md`
- SQLAlchemy: `references/sqlalchemy.md`
- pandas, Polars, PyArrow, or large files and query results: `references/dataframes.md`

## Tools

- Run Python and its tools with `uv run`, and add dependencies with `uv add`, not `pip`.
- Write code that passes the asset config even when the repo's config is weaker.
- Fix a lint instead of silencing it. If a rule is wrong for one line, use
  `# noqa: CODE` or `# ty: ignore[rule]` on that line and say why. Never silence a type
  error with `cast`, `Any`, or `# type: ignore`. Fix the model, the parser, or the
  signature. For an untyped library, wrap it once in a typed function.

## Newer than your training data

Check `requires-python` before you use these.

- 3.14: annotations are evaluated lazily. Don't add `from __future__ import annotations`
  or quote forward references.
- 3.14: t-strings (`t"..."`) build a `Template` instead of a `str`. Use them with APIs
  that accept templates, like SQLAlchemy 2.1's `tstring()`, which binds the values.
- 3.14: zstd is in the standard library as `compression.zstd`. Don't add `zstandard`.
- 3.15: `lazy import x` and `lazy from x import y` defer loading until first use. Use them
  for slow imports instead of moving imports into functions.
- 3.15: `MISSING = sentinel("MISSING")` replaces `_MISSING = object()`, and works in
  annotations like `int | MISSING`.
- 3.15: `frozendict` is a builtin. Use it instead of `MappingProxyType` for constant maps.
- 3.15: UTF-8 is the default encoding, so `open()` without `encoding=` reads UTF-8.
- 3.15: `[*xs for xs in groups]` flattens without `itertools.chain`.
- 3.15: `python -m profiling.sampling attach PID` profiles a running process with low
  overhead. Profile before you optimize.
- `httpx2` is the maintained fork of `httpx`, with the same API under a new import name.
  Use it in new code. Starlette's `TestClient` warns when only `httpx` is installed.
- Pydantic is v2: `model_validate`, `model_dump`, `field_validator`, and
  `model_config = ConfigDict(...)`. The v1 names (`parse_obj`, `.dict()`, `@validator`,
  `class Config`) are deprecated.

## Trust the types

Agents tend to guard against cases that the types already rule out. Each guard makes the
code longer and hides real bugs as silent defaults.

- Don't re-check what the signature or model guarantees. No `isinstance` that the type
  already settles (narrowing a union like `str | bytes` is fine), no `hasattr` or `getattr(obj, "field", default)` on known classes, no
  `is not None` on values that can't be `None`, and no `.get(key, default)` on data that
  was already validated. If the type is wrong, fix the type.
- Make a parameter optional only when a real caller passes `None` or omits it.
- Parse untrusted data once, at the boundary: request bodies, files, environment,
  queue messages, and third-party responses. Pass the parsed model inward, never
  `dict[str, Any]` or raw JSON.
- Use `Literal` or `StrEnum` instead of bare strings for a fixed set of values, and an
  enum instead of two bool flags that can't both be true.
- Don't add an ABC or `Protocol` with one implementation. Add it when a second
  implementation or a test fake needs it, in the module that uses it.

## Pydantic

- Let the model parse and convert. Don't pre-convert strings to `datetime`, `UUID`,
  `Decimal`, or enums, and don't check fields after construction. Use field types,
  `Field(gt=0)`, `Annotated` constraints, and validators instead.
- Use `Model.model_validate_json(raw)` instead of `json.loads` followed by validation,
  and `TypeAdapter(list[Item])` instead of a wrapper model. It fails the whole batch on
  one bad item, so validate item by item when bad items must be skipped or reported.
- Don't write `to_dict` or `from_row` mappers between models with the same fields. Use
  `model_validate(obj, from_attributes=True)`.
- Load settings once with `pydantic-settings` and pass them in. Don't call `os.getenv`
  across the codebase.
- Use plain dataclasses for internal values that are never parsed from outside.

## Errors

- Catch only an exception you can handle, around the smallest block that raises it. Let
  the rest reach the boundary (request handler, CLI entry point, job runner), which logs
  it once.
- Never turn an unexpected failure into a value: no `except ...: return None`, `{}`,
  `[]`, or `False` around I/O, parsing, or calls that shouldn't fail. Callers can't tell
  a failure from an empty result, and the bug moves downstream. Returning `None` for an
  expected "not found" is fine.
- Don't check what the callee checks anyway, like `path.exists()` before `open()`.
  It adds a race and a second error path.
- Raise a small set of domain exceptions from business code, and map them to HTTP codes
  or exit codes at the boundary.
- When a background loop must survive one bad item, catch `Exception` there, log it with
  `logger.exception`, and continue. That's the one place a broad catch belongs.

## Structure

- Use module-level functions. Don't write classes with only static methods, or
  stateless classes with one method plus an `__init__` that stores its arguments.
- Put code in the module that owns the concept, not in `utils.py` or `helpers.py`.
- Delete wrappers that only forward their arguments.
- Don't keep state in module globals, and don't build clients or connections at import
  time. Create them at startup and pass them in.
- Install the project as a package. Don't edit `sys.path`.

## Async

- Never block the event loop in `async def`. Ruff catches `requests`, `open`, and
  `time.sleep`, but not sync database sessions, sync SDK clients, or CPU-heavy work. Use
  async clients or `asyncio.to_thread`. In FastAPI, a plain `def` route or dependency
  runs in a thread pool, but a sync helper called from `async def` still blocks.
- Start tasks in an `asyncio.TaskGroup` so they're awaited and their errors surface. Use
  `asyncio.timeout()` for deadlines.
- Bound fan-out with a `Semaphore` or a worker pool. Don't `gather` thousands of calls.
- If you catch `CancelledError` to clean up, raise it again.

## Tests

- Test through public entry points: HTTP routes with `TestClient` or
  `httpx2.ASGITransport`, CLI functions, and service functions.
- Use a real database in tests (SQLite in memory or a test Postgres) rather than mocking
  sessions or repositories. Mock only external services, for example with
  `httpx2.MockTransport`.
- A bare `MagicMock()` accepts any attribute or call, so tests pass after a rename. Use
  a fake, or `create_autospec`.
- Use `pytest.mark.parametrize` instead of copied tests, and `tmp_path` and `monkeypatch`
  instead of real paths and `os.environ`.
- Don't test the framework, like Pydantic rejecting a missing field.
