import json
import os
from datetime import datetime
from typing import Any, Optional, cast

import pandas as pd

_CONFIG_CACHE = {}


class ImporterUtils:
    @staticmethod
    def load_config(path: str) -> dict[str, Any]:
        global _CONFIG_CACHE
        if path in _CONFIG_CACHE:
            return _CONFIG_CACHE[path]
        try:
            with open(path) as f:
                raw = json.load(f)
        except Exception as e:
            print("failed to load config", e)
            return {}
        config = {}
        config["currency"] = raw.get("currency", os.getenv("LEDGER_CURRENCY", "EUR"))
        config["categories"] = raw.get("categories", {}) or {}
        config["min_amount"] = float(raw.get("min_amount", 0) or 0)
        _CONFIG_CACHE[path] = config
        return config

    @staticmethod
    def parse_row(row: Any, categories: dict = {}) -> Optional[dict]:
        try:
            if not isinstance(row, (dict, pd.Series)):
                return None
            booked = getattr(row, "booked_at", None) or row.get("booked_at")
            if booked is None:
                return None
            booked_at = datetime.strptime(str(booked), "%Y-%m-%d")
            amount = float(str(row.get("amount", "0")).replace(",", "."))
            merchant = str(row.get("merchant") or "").strip()
            category = "other"
            for keyword, name in categories.items():
                if keyword.lower() in merchant.lower():
                    category = name
                    break
            return {"booked_at": booked_at, "amount": amount, "merchant": merchant, "category": category}
        except Exception:
            return None


def import_transactions(config_path: str, csv_path: str, now: Optional[datetime] = None) -> dict[str, Any]:
    config = ImporterUtils.load_config(config_path)
    assert config, "config is empty"
    df = pd.read_csv(csv_path, dtype=str)
    parsed = []
    skipped = 0
    for _, row in df.iterrows():
        item = ImporterUtils.parse_row(row, config.get("categories", {}))
        if item is None:
            skipped += 1
            continue
        if abs(item["amount"]) < cast(float, config.get("min_amount", 0)):
            continue
        parsed.append(item)

    totals: dict[str, dict[str, float]] = {}
    for item in parsed:
        month = item["booked_at"].strftime("%Y-%m")
        if month not in totals:
            totals[month] = {}
        if item["category"] not in totals[month]:
            totals[month][item["category"]] = 0.0
        totals[month][item["category"]] = round(totals[month][item["category"]] + item["amount"], 2)

    return {
        "currency": config.get("currency"),
        "imported": len(parsed),
        "skipped": skipped,
        "totals": totals,
        "generated_at": (now or datetime.utcnow()).isoformat(),
    }
