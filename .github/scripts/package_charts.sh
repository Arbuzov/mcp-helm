#!/usr/bin/env bash
set -euo pipefail

charts_dir="${1:-charts}"
chart_name="${2:-}"

repo_root=$(git rev-parse --show-toplevel)
cd "$repo_root"

package_dir=".cr-release-packages"
rm -rf "$package_dir"
mkdir -p "$package_dir"

if [[ -n "$chart_name" && "$chart_name" != "all" ]]; then
  chart_path="${charts_dir}/${chart_name}/Chart.yaml"
  if [[ ! -f "$chart_path" ]]; then
    echo "Chart ${chart_name} not found under ${charts_dir}."
    exit 1
  fi
  chart_files=("$chart_path")
else
  mapfile -t chart_files < <(
    find "$charts_dir" -mindepth 2 -maxdepth 2 -name Chart.yaml -print
  )
fi

if [[ ${#chart_files[@]} -eq 0 ]]; then
  echo "No charts found under ${charts_dir}."
  exit 1
fi

for chart_file in "${chart_files[@]}"; do
  chart_dir=$(dirname "$chart_file")
  echo "Packaging chart in ${chart_dir}..."
  cr package "$chart_dir" --package-path "$package_dir"
done
