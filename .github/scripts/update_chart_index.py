#!/usr/bin/env python3
import argparse
from pathlib import Path

import yaml


def main() -> int:
    parser = argparse.ArgumentParser(
        description=(
            "Update the Helm chart index and emit a list of chart/version"
            " pairs to delete."
        )
    )
    parser.add_argument("chart", help="Chart name or 'all'.")
    parser.add_argument("version", help="Chart version or 'all'.")
    parser.add_argument(
        "targets_path",
        help="Output path for chart/version pairs.",
    )
    args = parser.parse_args()

    chart = args.chart
    version = args.version
    targets_path = Path(args.targets_path)
    index_path = Path("index.yaml")

    data = {}
    if index_path.exists():
        with index_path.open() as handle:
            data = yaml.safe_load(handle) or {}

    entries = data.get("entries", {})
    targets = []

    if chart == "all" and version == "all":
        for chart_name, chart_entries in entries.items():
            for entry in chart_entries:
                entry_version = entry.get("version")
                if entry_version:
                    targets.append((chart_name, entry_version))
        data["entries"] = {}
    elif version == "all":
        chart_entries = entries.get(chart, [])
        targets = [
            (chart, entry.get("version"))
            for entry in chart_entries
            if entry.get("version")
        ]
        entries[chart] = []
        data["entries"] = entries
    else:
        targets = [(chart, version)]
        chart_entries = entries.get(chart, [])
        entries[chart] = [
            entry for entry in chart_entries
            if entry.get("version") != version
        ]
        data["entries"] = entries

    targets_path.write_text(
        "\n".join(
            f"{chart_name} {version_name}"
            for chart_name, version_name in targets
        )
    )

    if index_path.exists():
        with index_path.open("w") as handle:
            yaml.safe_dump(data, handle, sort_keys=False)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
