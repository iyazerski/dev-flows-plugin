---
type: llm
focus: trace
weight: 1
---

The raw orders are never materialized in memory: they are scanned lazily and aggregated in a streaming query (Polars scan_csv with the streaming engine or sink_parquet, DuckDB, or a PyArrow dataset). Only the aggregated result may be collected. pd.read_csv, pl.read_csv, or csv.DictReader into a list on the orders file fail this check
