#!/usr/bin/env bash
set -euo pipefail

base=${1:-HEAD~1}
head=${2:-HEAD}

changed_files=$(git diff --name-only "$base" "$head")

charts_changed=()
while IFS= read -r file; do
  if [[ $file =~ ^charts/([^/]+)/ ]]; then
    chart="${BASH_REMATCH[1]}"
    if [[ ! " ${charts_changed[*]} " =~ " ${chart} " ]]; then
      charts_changed+=("$chart")
    fi
  fi
done <<< "$changed_files"

for chart in "${charts_changed[@]:-}"; do
  chart_yaml="charts/$chart/Chart.yaml"
  if [[ -f "$chart_yaml" ]]; then
    current_version=$(grep '^version:' "$chart_yaml" | awk '{print $2}')
    if [[ -n "$current_version" ]]; then
      IFS='.' read -r major minor patch <<< "$current_version"
      patch=$((patch+1))
      new_version="${major}.${minor}.${patch}"
      sed -i "s/^version:.*/version: $new_version/" "$chart_yaml"
      echo "Bumped $chart to version $new_version"
    fi
  fi
done
