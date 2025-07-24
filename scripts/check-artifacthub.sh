#!/usr/bin/env bash
set -euo pipefail
required=(license maintainers)
for chart in charts/*; do
  for key in "${required[@]}"; do
    value=$(yq ".${key}" "$chart/Chart.yaml")
    if [[ "$value" == "null" ]]; then
      echo "Missing $key in $chart/Chart.yaml" >&2
      exit 1
    fi
  done
  echo "$chart ready"
done
