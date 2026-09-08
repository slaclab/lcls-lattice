#!/usr/bin/env python3

"""Add metadata.alias to Cheetah JSON element definitions.

The alias mapping is derived from
`bmad/conversion/from_oracle/lcls_elements.csv`.
"""

from __future__ import annotations

import argparse
import csv
import json
from pathlib import Path
from typing import Dict, Iterable
from urllib.parse import unquote


def parse_args() -> argparse.Namespace:
	repo_root = Path(__file__).resolve().parents[2]
	default_csv = repo_root / "bmad" / "conversion" / "from_oracle" / "lcls_elements.csv"
	default_json_dir = repo_root / "cheetah"

	parser = argparse.ArgumentParser(
		description="Inject metadata.alias into Cheetah JSON files using the LCLS element table."
	)
	parser.add_argument(
		"--csv",
		dest="csv_path",
		type=Path,
		default=default_csv,
		help=f"Path to lcls_elements.csv (default: {default_csv})",
	)
	parser.add_argument(
		"--json-dir",
		dest="json_dir",
		type=Path,
		default=default_json_dir,
		help=f"Directory containing JSON files to update (default: {default_json_dir})",
	)
	parser.add_argument(
		"--dry-run",
		action="store_true",
		help="Report changes without writing files.",
	)
	return parser.parse_args()


def base_alias_from_row(row: Dict[str, str]) -> str | None:
	# Prefer Control System Name for a stable base PV per element.
	control_name = (row.get("Control System Name") or "").strip()
	if control_name:
		parts = control_name.split(":")
		if len(parts) >= 3:
			return ":".join(parts[:3])
		return control_name

	# Fallback to IOC search when Control System Name is missing.
	ioc_search = (row.get("Ioc Captar Search") or "").strip()
	if ioc_search and ioc_search != "%25":
		decoded = unquote(ioc_search)
		alias = decoded.rstrip("%")
		if alias:
			return alias

	return None


def build_alias_map(csv_path: Path) -> Dict[str, str]:
	alias_map: Dict[str, str] = {}
	with csv_path.open("r", encoding="utf-8", newline="") as handle:
		reader = csv.DictReader(handle)
		for row in reader:
			element = (row.get("Element") or "").strip()
			if not element:
				continue

			alias = base_alias_from_row(row)
			if not alias:
				continue

			alias_map[element.upper()] = alias

	return alias_map


def iter_json_files(json_dir: Path) -> Iterable[Path]:
	yield from sorted(json_dir.glob("*.json"))


def update_json_file(file_path: Path, alias_map: Dict[str, str], dry_run: bool = False) -> tuple[int, int]:
	with file_path.open("r", encoding="utf-8") as handle:
		data = json.load(handle)

	elements = data.get("elements")
	if not isinstance(elements, dict):
		return 0, 0

	matched = 0
	updated = 0

	for element_name, element_def in elements.items():
		if not isinstance(element_name, str):
			continue
		if not (isinstance(element_def, list) and len(element_def) >= 2 and isinstance(element_def[1], dict)):
			continue

		alias = alias_map.get(element_name.upper())
		if not alias:
			continue

		matched += 1
		attributes = element_def[1]
		metadata = attributes.get("metadata")
		if not isinstance(metadata, dict):
			metadata = {}

		if metadata.get("alias") == alias:
			continue

		metadata["alias"] = alias
		attributes["metadata"] = metadata
		updated += 1

	if updated and not dry_run:
		with file_path.open("w", encoding="utf-8") as handle:
			json.dump(data, handle, indent=4, allow_nan=True)
			handle.write("\n")

	return matched, updated


def main() -> None:
	args = parse_args()

	csv_path = args.csv_path.expanduser().resolve()
	json_dir = args.json_dir.expanduser().resolve()

	if not csv_path.exists():
		raise FileNotFoundError(f"CSV file not found: {csv_path}")
	if not json_dir.exists() or not json_dir.is_dir():
		raise NotADirectoryError(f"JSON directory not found: {json_dir}")

	alias_map = build_alias_map(csv_path)
	if not alias_map:
		raise RuntimeError("No element aliases were loaded from CSV.")

	json_files = list(iter_json_files(json_dir))
	if not json_files:
		raise RuntimeError(f"No JSON files found in {json_dir}")

	total_matched = 0
	total_updated = 0

	for json_file in json_files:
		matched, updated = update_json_file(json_file, alias_map, dry_run=args.dry_run)
		total_matched += matched
		total_updated += updated
		print(f"{json_file.name}: matched={matched}, updated={updated}")

	mode = "dry-run" if args.dry_run else "write"
	print(
		f"Done ({mode}). files={len(json_files)}, matched={total_matched}, updated={total_updated}"
	)


if __name__ == "__main__":
	main()
