#!/usr/bin/env bash
set -euo pipefail

repo_root=$(git rev-parse --show-toplevel)
cd "$repo_root"

owner=$(cut -d '/' -f 1 <<< "$GITHUB_REPOSITORY")
repo=$(cut -d '/' -f 2 <<< "$GITHUB_REPOSITORY")

package_dir=".cr-release-packages"
if [[ ! -d "$package_dir" ]]; then
  echo "Package directory ${package_dir} does not exist."
  exit 1
fi

commit_sha=$(git rev-parse HEAD)

echo "Reuploading chart packages from ${package_dir}..."
cr upload \
  --owner "$owner" \
  --repo "$repo" \
  --commit "$commit_sha" \
  --package-path "$package_dir"

echo "Updating charts repo index..."
cr index \
  --owner "$owner" \
  --repo "$repo" \
  --package-path "$package_dir" \
  --push \
  --pages-branch "gh-pages"
