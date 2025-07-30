# MCP Helm Charts

This repository contains Helm charts used by the MCP project. All charts are stored in the `charts` directory.

## Available charts

- **atlassian** – Helm chart moved from the repository root to `charts/atlassian`. See [its README](charts/atlassian/README.md) for details.
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
