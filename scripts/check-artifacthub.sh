#!/usr/bin/env bash
set -euo pipefail

required=(license maintainers)

charts=("${@}")
if [[ ${#charts[@]} -eq 0 ]]; then
  charts=(charts/*)
fi

status=0
for chart in "${charts[@]}"; do
  chart_yaml="$chart/Chart.yaml"
  if [[ ! -f "$chart_yaml" ]]; then
    echo "Skipping $chart: no Chart.yaml" >&2
    continue
  fi
  for key in "${required[@]}"; do
    value=$(yq ".${key}" "$chart_yaml")
    if [[ "$value" == "null" ]]; then
      echo "Missing $key in $chart_yaml" >&2
      status=1
    fi
  done
  echo "$chart ready"
done
exit $status
