#!/usr/bin/env bash
set -euo pipefail

repo="${GITHUB_REPOSITORY}"

if [[ -z "${CHART:-}" || -z "${VERSION:-}" ]]; then
  echo "CHART and VERSION must be set."
  exit 1
fi

tmpdir="$(mktemp -d)"
trap 'rm -rf "${tmpdir}"' EXIT

git -C "${tmpdir}" clone --branch gh-pages --depth 1 \
  "https://github.com/${repo}.git" gh-pages \
  || { echo "gh-pages branch not found; nothing to clean up."; exit 0; }

cd "${tmpdir}/gh-pages"

targets_file="${tmpdir}/targets.txt"
python "${GITHUB_WORKSPACE}/.github/scripts/update_chart_index.py" \
  "${CHART}" "${VERSION}" "${targets_file}"

if [[ ! -s "${targets_file}" ]]; then
  if [[ "${CHART}" == "all" || "${VERSION}" == "all" ]]; then
    if [[ ! -f index.yaml ]]; then
      echo "index.yaml is missing; no chart versions found for bulk cleanup."
    else
      echo "index.yaml contains no matching entries; no releases or artifacts deleted."
    fi
  else
    echo "No matching chart versions found to delete."
  fi
  exit 0
fi

while read -r target_chart target_version; do
  tag="${target_chart}-${target_version}"
  echo "Deleting GitHub release/tag ${tag} in ${repo}..."
  if gh release view "${tag}" >/dev/null 2>&1; then
    gh release delete "${tag}" --cleanup-tag --yes
  else
    echo "Release ${tag} not found; skipping deletion."
  fi

  rm -f "${target_chart}-${target_version}.tgz" \
    "${target_chart}-${target_version}.tgz.prov"
done < "${targets_file}"

git config user.name "$GITHUB_ACTOR"
git config user.email "$GITHUB_ACTOR@users.noreply.github.com"

git add -A
if git diff --cached --quiet; then
  echo "No changes to commit in gh-pages."
  exit 0
fi

git commit -m "Remove ${CHART} ${VERSION} from index"
git push origin gh-pages
