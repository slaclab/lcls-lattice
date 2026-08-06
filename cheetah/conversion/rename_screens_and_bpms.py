#!/usr/bin/env python3

"""Retype Cheetah `Marker` elements into `Screen` and `BPM` elements.

The generated Cheetah lattices collapse every diagnostic to a zero-length
`Marker`, which carries no readback behaviour. Profile monitors and BPMs are
identified from `metadata.alias` (carried through from the Bmad `[alias]`
attributes in `bmad/master/LCLS*_devicenames.bmad`), falling back to the `Keyword`
column of `bmad/conversion/from_oracle/lcls_elements.csv`, and rewritten as the
corresponding Cheetah element class.

Screen camera parameters come from `profmon_info.yaml`; screens missing from that
table fall back to a 1024 px x 10 um placeholder and are reported.

The new elements are written active, so the lattice reads back out of the box;
pass `--inactive` to leave activation to the consumer.
"""

from __future__ import annotations

import argparse
import csv
import json
from pathlib import Path
from typing import Any, Dict, Iterable, Tuple

# Alias prefixes that identify a diagnostic, e.g. "otrs:diag0:396".
SCREEN_ALIAS_PREFIXES = {"OTRS", "YAGS", "PROF"}
BPM_ALIAS_PREFIXES = {"BPMS"}

# `Keyword` values in lcls_elements.csv, used when the alias is absent or
# names something other than the diagnostic itself.
SCREEN_KEYWORDS = {"PROF"}
BPM_KEYWORDS = {"BPM"}

# Placeholder camera parameters for screens absent from `profmon_info.yaml`,
# written explicitly so the lattice is self-describing. A 1024 px x 10 um screen
# is a 10.24 mm field of view -- the right order of magnitude for an LCLS profile
# monitor, unlike Cheetah's own default of 1 mm pixels (a 1.02 m screen), so beam
# sizes on an uncalibrated screen stay physically plausible. Screens using these
# values are reported as a warning; replace them with measured ones.
DEFAULT_RESOLUTION = [1024, 1024]
DEFAULT_PIXEL_SIZE = [10.0e-6, 10.0e-6]


def parse_args() -> argparse.Namespace:
	repo_root = Path(__file__).resolve().parents[2]
	default_csv = repo_root / "bmad" / "conversion" / "from_oracle" / "lcls_elements.csv"
	default_json_dir = repo_root / "cheetah"
	default_profmon = Path(__file__).resolve().parent / "profmon_info.yaml"

	parser = argparse.ArgumentParser(
		description="Retype Marker elements as Screen/BPM in Cheetah JSON lattices."
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
		"--profmon-info",
		dest="profmon_path",
		type=Path,
		default=default_profmon,
		help=f"Path to profile monitor camera parameters (default: {default_profmon})",
	)
	parser.add_argument(
		"--inactive",
		dest="is_active",
		action="store_false",
		help="Write the new elements with is_active=false (default: true).",
	)
	parser.add_argument(
		"--dry-run",
		action="store_true",
		help="Report changes without writing files.",
	)
	return parser.parse_args()


class CompactJSONEncoder(json.JSONEncoder):
	"""A JSON Encoder which only indents the first two levels.

	Vendored from `cheetah.latticejson` so this script stays dependency-free.
	Cheetah writes the lattices with this encoder; using plain `json.dump` here
	would reformat every file (roughly doubling its size) and bury the real
	change in whitespace noise.
	"""

	def encode(self, obj, level=0):
		if isinstance(obj, dict) and level < 2:
			items_indent = (level + 1) * self.indent * " "
			items_string = ",\n".join(
				f"{items_indent}{json.dumps(key)}: {self.encode(value, level=level + 1)}"
				for key, value in obj.items()
			)
			dict_indent = level * self.indent * " "
			newline = "\n" if level == 0 else ""
			return f"{{\n{items_string}\n{dict_indent}}}{newline}"
		else:
			return json.dumps(obj)


def build_keyword_map(csv_path: Path) -> Dict[str, str]:
	"""Map element name to its `Keyword` (device class) from the LCLS table."""
	keyword_map: Dict[str, str] = {}
	with csv_path.open("r", encoding="utf-8", newline="") as handle:
		# The first line is a column-group banner ("EPICS Channel Access
		# Device", "Sections Table Data", ...); the real header is on line two.
		next(handle)
		reader = csv.DictReader(handle)
		for row in reader:
			element = (row.get("Element") or "").strip()
			keyword = (row.get("Keyword") or "").strip()
			if element and keyword:
				keyword_map[element.upper()] = keyword.upper()

	return keyword_map


def load_profmon_info(
	profmon_path: Path,
) -> Tuple[Dict[str, Dict[str, Any]], Dict[str, Dict[str, Any]]]:
	"""Load screen camera parameters keyed by both alias and element name.

	Returns `(by_alias, by_element)`, each mapping to a dict of Cheetah `Screen`
	attributes. `shape` is used verbatim as `resolution` and `pixel_size` is
	converted from microns to meters, matching how virtual-accelerator consumes
	the same table.
	"""
	try:
		import yaml
	except ImportError as error:  # pragma: no cover
		raise RuntimeError(
			"PyYAML is required to read profile monitor parameters. "
			"Install it with `pip install pyyaml`."
		) from error

	with profmon_path.open("r", encoding="utf-8") as handle:
		raw = yaml.safe_load(handle) or {}

	by_alias: Dict[str, Dict[str, Any]] = {}
	by_element: Dict[str, Dict[str, Any]] = {}

	for element, config in raw.items():
		shape = config.get("shape")
		pixel_size = config.get("pixel_size")
		if not shape or pixel_size is None:
			continue

		params = {
			"resolution": [int(value) for value in shape],
			# Divide rather than multiply by 1e-6: `12.66 * 1e-6` rounds to
			# 1.2659999999999999e-05, while `12.66 / 1e6` gives the exact
			# nearest double, keeping the JSON readable.
			"pixel_size": [float(pixel_size) / 1e6] * 2,
		}

		by_element[str(element).upper()] = params
		alias = (config.get("name") or "").strip()
		if alias:
			by_alias[alias.upper()] = params

	return by_alias, by_element


def classify(
	element_name: str, attributes: Dict[str, Any], keyword_map: Dict[str, str]
) -> str | None:
	"""Return "Screen", "BPM", or None for an element definition.

	The alias prefix is the primary signal; the CSV `Keyword` covers elements
	whose alias is missing (the `_yag` companion targets), names a different
	device (`yag01b` -> `movr:gunb:753`), carries the device type in a field
	other than the prefix (`p30013` -> `li30:prof:13`), or is misspelled
	upstream (`rfb0h08` -> `bmps:htr:475`).
	"""
	metadata = attributes.get("metadata")
	alias = ""
	if isinstance(metadata, dict):
		alias = (metadata.get("alias") or "").strip()

	prefix = alias.split(":")[0].upper()
	if prefix in SCREEN_ALIAS_PREFIXES:
		return "Screen"
	if prefix in BPM_ALIAS_PREFIXES:
		return "BPM"

	keyword = keyword_map.get(element_name.upper(), "")
	if keyword in SCREEN_KEYWORDS:
		return "Screen"
	if keyword in BPM_KEYWORDS:
		return "BPM"

	return None


def build_attributes(
	element_name: str,
	target_class: str,
	attributes: Dict[str, Any],
	profmon_by_alias: Dict[str, Dict[str, Any]],
	profmon_by_element: Dict[str, Dict[str, Any]],
	is_active: bool = True,
) -> Tuple[Dict[str, Any], bool]:
	"""Build the new attribute dict, and whether screen params were defaulted.

	Only the features we have data for are written; the remaining `Screen`
	features (`binning`, `misalignment`, `method`, `kde_bandwidth`) keep Cheetah's
	defaults. `metadata` is carried over verbatim so the alias and type survive.
	"""
	metadata = attributes.get("metadata")
	if not isinstance(metadata, dict):
		metadata = {}

	new_attributes: Dict[str, Any] = {}
	used_defaults = False

	if target_class == "Screen":
		alias = (metadata.get("alias") or "").strip().upper()
		params = profmon_by_alias.get(alias) or profmon_by_element.get(
			element_name.upper()
		)
		if params is None:
			params = {
				"resolution": list(DEFAULT_RESOLUTION),
				"pixel_size": list(DEFAULT_PIXEL_SIZE),
			}
			used_defaults = True

		new_attributes["resolution"] = params["resolution"]
		new_attributes["pixel_size"] = params["pixel_size"]

	# Active by default so the lattice is usable as-is: an inactive `Screen`
	# records no image and an inactive `BPM` no reading, and Cheetah's own default
	# is `False`. Pass `--inactive` to defer activation to the consumer instead
	# (virtual-accelerator drives this at runtime via the PNEUMATIC PV).
	new_attributes["is_active"] = is_active
	new_attributes["metadata"] = metadata

	return new_attributes, used_defaults


def iter_json_files(json_dir: Path) -> Iterable[Path]:
	yield from sorted(json_dir.glob("*.json"))


def update_json_file(
	file_path: Path,
	keyword_map: Dict[str, str],
	profmon_by_alias: Dict[str, Dict[str, Any]],
	profmon_by_element: Dict[str, Dict[str, Any]],
	is_active: bool = True,
	dry_run: bool = False,
) -> Dict[str, Any]:
	"""Retype one lattice file in place, returning a per-file report.

	Both `Marker`s (converted) and elements already retyped by an earlier run
	(refreshed) are rewritten, so changes to `profmon_info.yaml` or `--inactive`
	land on a re-run without having to revert the file first. The file is only
	written when something actually differs.
	"""
	with file_path.open("r", encoding="utf-8") as handle:
		data = json.load(handle)

	report: Dict[str, Any] = {
		"screens": 0,
		"bpms": 0,
		"converted": 0,
		"refreshed": 0,
		"defaulted": [],
		"skipped": [],
		"missing_from_csv": [],
	}

	elements = data.get("elements")
	if not isinstance(elements, dict):
		return report

	changed = 0

	for element_name, element_def in elements.items():
		if not isinstance(element_name, str):
			continue
		if not (
			isinstance(element_def, list)
			and len(element_def) >= 2
			and isinstance(element_def[1], dict)
		):
			continue

		attributes = element_def[1]
		target_class = classify(element_name, attributes, keyword_map)
		if target_class is None:
			continue

		current_class = element_def[0]
		if current_class not in ("Marker", target_class):
			# Notably the undulator RF BPMs, which are Drifts of finite length.
			# Cheetah's BPM is zero-length, so retyping them would shorten the
			# lattice.
			report["skipped"].append(
				f"{element_name} ({current_class} -> {target_class})"
			)
			continue

		if element_name.upper() not in keyword_map:
			report["missing_from_csv"].append(element_name)

		new_attributes, used_defaults = build_attributes(
			element_name,
			target_class,
			attributes,
			profmon_by_alias,
			profmon_by_element,
			is_active=is_active,
		)

		# A `Screen`/`BPM` from an earlier run is rebuilt rather than skipped, so
		# edits to `profmon_info.yaml` or `--inactive` take effect on a re-run.
		# Rebuilding is still a no-op when nothing changed, keeping this
		# idempotent.
		if element_def[0] != target_class or element_def[1] != new_attributes:
			changed += 1
			if current_class == "Marker":
				report["converted"] += 1
			else:
				report["refreshed"] += 1

		element_def[0] = target_class
		element_def[1] = new_attributes

		if target_class == "Screen":
			report["screens"] += 1
			if used_defaults:
				report["defaulted"].append(element_name)
		else:
			report["bpms"] += 1

	if changed and not dry_run:
		# Match cheetah's own output format exactly: first two levels indented,
		# no trailing newline.
		with file_path.open("w", encoding="utf-8") as handle:
			handle.write(json.dumps(data, cls=CompactJSONEncoder, indent=4))

	return report


def print_warning_block(title: str, names: Iterable[str]) -> None:
	names = list(names)
	if not names:
		return

	print(f"\nWARNING: {title} ({len(names)}):")
	for name in names:
		print(f"  {name}")


def main() -> None:
	args = parse_args()

	csv_path = args.csv_path.expanduser().resolve()
	json_dir = args.json_dir.expanduser().resolve()
	profmon_path = args.profmon_path.expanduser().resolve()

	if not csv_path.exists():
		raise FileNotFoundError(f"CSV file not found: {csv_path}")
	if not json_dir.exists() or not json_dir.is_dir():
		raise NotADirectoryError(f"JSON directory not found: {json_dir}")
	if not profmon_path.exists():
		raise FileNotFoundError(f"Profile monitor info not found: {profmon_path}")

	keyword_map = build_keyword_map(csv_path)
	if not keyword_map:
		raise RuntimeError("No element keywords were loaded from CSV.")

	profmon_by_alias, profmon_by_element = load_profmon_info(profmon_path)

	json_files = list(iter_json_files(json_dir))
	if not json_files:
		raise RuntimeError(f"No JSON files found in {json_dir}")

	totals = {"screens": 0, "bpms": 0, "converted": 0, "refreshed": 0}
	defaulted: list[str] = []
	skipped: list[str] = []
	missing_from_csv: list[str] = []

	for json_file in json_files:
		report = update_json_file(
			json_file,
			keyword_map,
			profmon_by_alias,
			profmon_by_element,
			is_active=args.is_active,
			dry_run=args.dry_run,
		)
		for key in totals:
			totals[key] += report[key]
		defaulted += [f"{json_file.name}: {name}" for name in report["defaulted"]]
		skipped += [f"{json_file.name}: {name}" for name in report["skipped"]]
		missing_from_csv += [
			f"{json_file.name}: {name}" for name in report["missing_from_csv"]
		]
		print(
			f"{json_file.name}: screens={report['screens']}, bpms={report['bpms']} "
			f"(converted={report['converted']}, refreshed={report['refreshed']}, "
			f"skipped={len(report['skipped'])})"
		)

	print_warning_block(
		"screens using placeholder resolution/pixel_size, "
		"add them to profmon_info.yaml",
		defaulted,
	)
	print_warning_block(
		"diagnostics left untouched because they are neither Markers nor already "
		"the target class (retyping would change the lattice length)",
		skipped,
	)
	print_warning_block(
		"elements classified from their alias alone, absent from lcls_elements.csv",
		missing_from_csv,
	)

	mode = "dry-run" if args.dry_run else "write"
	print(
		f"\nDone ({mode}). files={len(json_files)}, "
		f"screens={totals['screens']}, bpms={totals['bpms']}, "
		f"changed={totals['converted'] + totals['refreshed']} "
		f"(converted={totals['converted']}, refreshed={totals['refreshed']})"
	)


if __name__ == "__main__":
	main()
