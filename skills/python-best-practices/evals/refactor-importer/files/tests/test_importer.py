import json
from datetime import UTC, datetime
from pathlib import Path

from ledger.importer import import_transactions

CSV = """booked_at,amount,merchant
2026-01-03,-12.50,Coffee Corner
2026-01-05,"-40,10",City Market
2026-01-20,2500.00,ACME Payroll
2026-02-01,-0.20,Coffee Corner
2026-02-02,not-a-number,City Market
2026-02-14,-60.00,Rose Garden
,-5.00,City Market
"""


def write_inputs(tmp_path: Path) -> tuple[Path, Path]:
    config = tmp_path / "config.json"
    config.write_text(
        json.dumps(
            {
                "currency": "EUR",
                "min_amount": 0.5,
                "categories": {
                    "coffee": "food",
                    "market": "groceries",
                    "payroll": "income",
                },
            }
        )
    )
    csv = tmp_path / "transactions.csv"
    csv.write_text(CSV)
    return config, csv


def test_import_transactions(tmp_path: Path) -> None:
    config, csv = write_inputs(tmp_path)

    result = import_transactions(
        str(config), str(csv), now=datetime(2026, 3, 1, tzinfo=UTC)
    )

    assert result["currency"] == "EUR"
    assert result["imported"] == 4
    assert result["skipped"] == 2
    assert result["totals"] == {
        "2026-01": {"food": -12.5, "groceries": -40.1, "income": 2500.0},
        "2026-02": {"other": -60.0},
    }
    assert result["generated_at"] == "2026-03-01T00:00:00+00:00"
