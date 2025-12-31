# MCP Helm Charts

This repository contains Helm charts used by the MCP project. All charts are stored in the `charts` directory.

## Available charts

- **atlassian** – Helm chart moved from the repository root to `charts/atlassian`. See [its README](charts/atlassian/README.md) for details.
- **claude-code-api** – Helm chart for the Claude Code OpenAI-compatible gateway. See [its README](charts/claude-code-api/README.md) for usage information.
- **gitlab** – Helm chart for the GitLab MCP server. See [its README](charts/gitlab/README.md) for usage information.
- **kubernetes** – Helm chart for running the MCP server locally. See [its README](charts/kubernetes/README.md) for details.
- **homeassistant** – Helm chart for deploying the Home Assistant MCP server. See [its README](charts/homeassistant/README.md).
- **mcpo** – Helm chart for deploying the mcpo proxy server. See [its README](charts/mcpo/README.md).
- **mcp-library** – Library chart providing common helper templates.

## Development container

A [Dev Container](https://containers.dev/) configuration is provided in the `.devcontainer` directory. It includes Helm and related tools to lint and test the charts locally.

## Using the chart repository

When working with charts that depend on the `mcp-library` chart, add this repository so Helm can resolve the dependency:

```bash
helm repo add mcp https://arbuzov.github.io/mcp-helm/
helm repo update
```

After adding the repository, run `helm dependency update` inside the chart directory to fetch the required dependencies.

## Release management

Chart releases are published through the `Release Charts` GitHub Actions workflow (see `.github/workflows/chart-release.yml`). Any merge to `master` that touches `charts/` triggers a release. You can also manage releases directly from the workflow dispatch form.

### Delete or reupload a chart release

Use the `Release Charts` workflow with the `action` input set to `delete` or `reupload`. This runs entirely on GitHub Actions and updates the `gh-pages` index plus GitHub releases.

Workflow dispatch inputs:

- `action`: `release` (default), `delete`, or `reupload`.
- `chart`: chart name (required for delete/reupload).
- `version`: chart version (required for delete/reupload).

Notes:

- The release tag format is `<chart>-<version>` (e.g. `mcpo-0.3.2`).
- Reuploading keeps the same chart version, so only do it when you need to re-publish identical content.
