# DataFrames and tabular data

Agents reach for pandas out of habit, read whole files into memory, and loop over rows.
On real data that turns seconds into hours.

## Which library

- **New code:** Polars, with the lazy API. Start from `pl.scan_parquet`, `pl.scan_csv`,
  or `pl.scan_ndjson`. Select columns and filter early, then call `collect()` once at
  the end, or `sink_parquet()` to stream the result to disk.
- **I/O and interchange:** PyArrow, for Parquet datasets, Arrow IPC, and zero-copy
  handoff between Polars, DuckDB, and database drivers.
- **SQL over files:** DuckDB, when the job reads like a query.
- **Existing pandas code:** don't rewrite it unasked. Take the cheap wins: read with
  `engine="pyarrow"` and `dtype_backend="pyarrow"`, and load only the needed columns
  with `usecols` or `columns`. When a pandas path is slow, suggest moving it to Polars.

## Pitfalls

- **Row loops.** `iterrows`, `itertuples`, `apply(axis=1)`, `map_elements`, and
  `for row in df.rows()` run Python for every row. Use column expressions:
  `pl.when`, the `str`, `dt`, and `list` namespaces, and joins.
- **Growing a frame in a loop.** `concat` inside a loop copies everything each time.
  Collect the parts in a list and concatenate once, or build columns directly.
- **Read everything, then filter.** Push column selection and filters into the scan or
  the SQL query, so they run before data is loaded.
- **CSV or JSON between steps.** Write Parquet. It keeps types, compresses well, and
  reads only the columns you ask for.
- **Database rows through ORM objects.** Don't load ORM objects and turn them into
  dicts and then a frame. Read the query result directly with `pl.read_database_uri`
  (ConnectorX or ADBC) or `pl.read_database`, and aggregate in the database when you
  can.
- **Switching libraries mid-pipeline.** `to_pandas()` for one operation and back
  copies the data twice. Convert only at the edge, for a library that needs pandas.
- **Python objects in columns.** Dates kept as strings, and Python `Decimal` or `dict`
  objects in pandas `object` columns, are slow and untyped. Parse to native dtypes when
  reading (including Polars `Decimal` for money), with `schema_overrides` or
  `try_parse_dates=True`.
- **Many small steps.** Add independent columns with one `with_columns([...])` call, not
  one call per column in a loop. Expressions in one call can't use each other's output. Don't `collect()` in the middle and call `.lazy()` again.
- **Relying on row order.** Polars' streaming engine doesn't keep row order for
  `group_by`, joins, or `unpivot`. Sort explicitly, or pass `maintain_order`.
- **Chained assignment in pandas.** With copy-on-write, `df[mask]["col"] = v` never
  writes. Use `df.loc[mask, "col"] = v`.
