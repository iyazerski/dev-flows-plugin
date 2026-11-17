# SQLAlchemy

## 2.x style

Agents still write SQLAlchemy 1.x code. Use the 2.x API:

- Models: `DeclarativeBase`, `Mapped[...]`, and `mapped_column()`, not `Column` on
  `declarative_base()`.
- Queries: `select()` with `session.scalars()` or `session.execute()`, and
  `session.get(Model, pk)`. Not `session.query()`.
- One row: `scalar_one()` or `scalar_one_or_none()`. `first()` on a query without
  `order_by` returns an arbitrary row and hides duplicates.
- Bulk changes: `update()`, `delete()`, and `insert().values([...])` statements, not a
  loop over loaded objects.

## Queries

- Filter, sort, paginate, count, and aggregate in SQL. Don't load rows to filter them
  in Python, and don't count with `len(...all())`. Use `select(func.count())`.
- Load relationships you iterate with `selectinload` or `joinedload`. Set
  `lazy="raise"` on relationships so a missed eager load fails in tests instead of
  causing N+1 queries. Under asyncio, a lazy load raises `MissingGreenlet`.
- Always bind values. Never build SQL with f-strings or `%`.
- Don't select and then insert to avoid duplicates. Two requests can both pass the
  check. Rely on a unique constraint and handle `IntegrityError`, or use the dialect's
  `insert(...).on_conflict_do_update()`.
- Stream large results with `yield_per()`, or read them straight into a dataframe (see
  `dataframes.md`).
- Check that a new filter or sort on a large table can use an existing index. When it
  can't, add one with an Alembic migration.
- Change state with a conditional update, like
  `update(Order).where(Order.id == id, Order.status == "pending")`, and check the row
  count, or lock the row with `with_for_update()`. Read, check, then write lets two
  requests both pass the check.

## Sessions and transactions

- Use one session per request, job, or unit of work. Never share a session across
  threads or tasks, and never keep one in a module global.
- Commit once per unit of work, at the end of the service function. Don't commit inside
  repository methods or loops: a failure halfway leaves partial writes. Use
  `session.begin()` only where you open the session. If a dependency already queried
  it, a transaction is open and `begin()` raises.
- After a failed flush or commit, the session needs `rollback()` before you use it
  again.
- With `AsyncSession`, set `expire_on_commit=False`. Otherwise reading an attribute
  after commit triggers a reload that fails outside an `await`.

## Migrations

- Create migrations with `alembic revision --autogenerate`, then edit the generated
  file. Don't write them from scratch.
- Don't call `metadata.create_all()` at app startup in place of migrations.
