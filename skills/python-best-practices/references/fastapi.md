# FastAPI apps

This file covers where code goes in a FastAPI app.

## Layers

Follow the repo's existing layer names. When it has none, use these three:

- **Routes** declare inputs, call one service function, and return its result. No
  queries, `commit()`, business rules, auth checks, or outbound HTTP calls.
- **Services** (or use cases) hold business rules and own the transaction. They take
  plain values, models, and a session or repository. They know nothing about HTTP: no
  `Request`, `HTTPException`, status codes, or response classes.
- **Repositories** (or infrastructure) run queries and call external systems. They
  return ORM objects or models, not dicts or raw rows.

In a small app, services may run queries on the session directly. Add a repository when
the repo already has them or when several services share a query. Don't add one that
only wraps `session.get`.

## Dependencies

- Authenticate in one dependency that returns the user, exposed as an alias like
  `CurrentUser = Annotated[User, Depends(get_current_user)]`. Never read the
  `Authorization` header, a cookie, or a token inside a route.
- When no route in a router needs the user object, put the check on the router:
  `APIRouter(dependencies=[Depends(get_current_user)])`.
- Load a path resource and check access in a dependency (for example `OwnedOrder`), not
  by repeating "fetch, compare owner, raise 404" in every route. Return 404, not 403,
  for another user's resource, so IDs don't leak.
- Open one session per request in a `yield` dependency. Its code after `yield` runs
  after the response is sent by default, so a commit there can fail after the client
  saw success. Commit in the service, or declare the dependency with
  `scope="function"`.
- Create shared clients (database engine, `httpx2.AsyncClient`) in `lifespan` and
  expose them through dependencies. Don't build them per request or at import time.
- Read settings through a cached dependency so tests can replace them with
  `app.dependency_overrides`.

## Errors

- Services raise domain exceptions like `NotFoundError` and `ConflictError`. Register
  one exception handler that maps them to status codes. Routes don't catch and
  translate them.
- Raise `HTTPException` only in routes and dependencies, for HTTP concerns like missing
  credentials.
- Never answer a failure with status 200 and an error body, and never send exception
  text or stack traces to clients.

## Responses

- Return the service result and let the return type or `response_model` validate,
  filter, and serialize it. Set `from_attributes=True` on response models built from
  ORM objects. Don't hand-build dicts or write mapper functions.
- Keep request and response models separate from ORM models, so internal columns like
  password hashes can't leak.
- Paginate list endpoints with a bounded `limit`, and filter and sort in SQL.

## Tests

- Call the app through `TestClient` or `httpx2.ASGITransport`. Point the session
  dependency at a test database with `app.dependency_overrides`.
- Override authentication only in tests that aren't about authentication. Keep at
  least one test that sends no credentials and one that requests another user's
  resource.
