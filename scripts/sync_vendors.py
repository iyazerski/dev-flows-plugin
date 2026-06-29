"""Sync vendored files declared by lock files under vendor/."""

from __future__ import annotations

import argparse
import json
from dataclasses import dataclass
from pathlib import Path
from typing import Any
from urllib.parse import quote
from urllib.request import Request, urlopen


REPO_ROOT = Path(__file__).resolve().parents[1]
DEFAULT_LOCK_GLOB = "vendor/**/*.lock.json"


@dataclass(frozen=True)
class VendorFile:
    """Represent one vendored file mapping from upstream source to local destination."""

    source: str
    destination: str


@dataclass(frozen=True)
class GithubSource:
    """Represent a pinned GitHub repository source for vendored files."""

    repo: str
    ref: str


@dataclass(frozen=True)
class VendorLock:
    """Represent one validated vendor lock file."""

    path: Path
    source: GithubSource
    files: list[VendorFile]


def relative_path(value: str, field_name: str) -> str:
    """Validate and return a repository-relative path from a lock file."""
    path = Path(value)
    if path.is_absolute() or ".." in path.parts:
        raise ValueError(f"{field_name} must be a relative path inside the repository: {value}")
    return value


def required_string(data: dict[str, Any], key: str, context: str) -> str:
    """Read a required string value from parsed lock data."""
    value = data[key]
    if not isinstance(value, str) or value == "":
        raise ValueError(f"{context}.{key} must be a non-empty string")
    return value


def required_dict(data: dict[str, Any], key: str, context: str) -> dict[str, Any]:
    """Read a required object value from parsed lock data."""
    value = data[key]
    if not isinstance(value, dict):
        raise ValueError(f"{context}.{key} must be an object")
    return value


def required_list(data: dict[str, Any], key: str, context: str) -> list[Any]:
    """Read a required list value from parsed lock data."""
    value = data[key]
    if not isinstance(value, list):
        raise ValueError(f"{context}.{key} must be a list")
    return value


def parse_vendor_file(data: dict[str, Any], context: str) -> VendorFile:
    """Parse and validate one file mapping from a lock file."""
    source = relative_path(required_string(data, "source", context), f"{context}.source")
    destination = relative_path(
        required_string(data, "destination", context),
        f"{context}.destination",
    )
    return VendorFile(source=source, destination=destination)


def parse_lock(path: Path) -> VendorLock:
    """Parse and validate one vendor lock file."""
    data = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(data, dict):
        raise ValueError(f"{path} must contain a JSON object")

    source_data = required_dict(data, "source", str(path))
    source_type = required_string(source_data, "type", f"{path}.source")
    if source_type != "github":
        raise ValueError(f"{path}.source.type must be github")

    source = GithubSource(
        repo=required_string(source_data, "repo", f"{path}.source"),
        ref=required_string(source_data, "ref", f"{path}.source"),
    )

    files: list[VendorFile] = []

    for index, file_data in enumerate(required_list(data, "files", str(path))):
        file_context = f"{path}.files[{index}]"
        if not isinstance(file_data, dict):
            raise ValueError(f"{file_context} must be an object")
        files.append(parse_vendor_file(file_data, file_context))

    return VendorLock(path=path, source=source, files=files)


def lock_paths(arguments: list[str]) -> list[Path]:
    """Return explicit lock files or every default vendor lock file."""
    if arguments:
        return [Path(argument) for argument in arguments]
    return sorted(REPO_ROOT.glob(DEFAULT_LOCK_GLOB))


def local_destination(path: str) -> Path:
    """Resolve a repository-relative destination path."""
    destination = (REPO_ROOT / path).resolve()
    if not destination.is_relative_to(REPO_ROOT):
        raise ValueError(f"destination must stay inside the repository: {path}")
    return destination


def fetch_github_text(source: GithubSource, source_path: str) -> str:
    """Fetch one pinned GitHub file as UTF-8 text."""
    quoted_path = quote(source_path, safe="/")
    url = f"https://raw.githubusercontent.com/{source.repo}/{source.ref}/{quoted_path}"
    request = Request(url, headers={"User-Agent": "dev-flows-plugin-vendor-sync"})
    with urlopen(request, timeout=30) as response:
        return response.read().decode()


def sync_vendor_file(lock: VendorLock, vendor_file: VendorFile) -> None:
    """Overwrite one local vendored file with its pinned upstream contents."""
    destination = local_destination(vendor_file.destination)
    destination.parent.mkdir(parents=True, exist_ok=True)
    destination.write_text(fetch_github_text(lock.source, vendor_file.source), encoding="utf-8")
    print(f"{lock.path}: synced {vendor_file.destination}")


def sync_lock(path: Path) -> None:
    """Sync all files declared by one vendor lock file."""
    lock = parse_lock(path)
    for vendor_file in lock.files:
        sync_vendor_file(lock, vendor_file)


def parse_args() -> argparse.Namespace:
    """Parse command-line arguments for vendor syncing."""
    parser = argparse.ArgumentParser(description="Sync files declared by vendor/**/*.lock.json files.")
    parser.add_argument("locks", nargs="*", help="Optional lock files to sync.")
    return parser.parse_args()


def main() -> None:
    """Sync every requested vendor lock file."""
    args = parse_args()
    for path in lock_paths(args.locks):
        sync_lock(path)


if __name__ == "__main__":
    main()
