# MCP Helm Charts

This repository contains Helm charts used by the MCP project. All charts are stored in the `charts` directory.

## Available charts

- **atlassian** – Helm chart moved from the repository root to `charts/atlassian`. See [its README](charts/atlassian/README.md) for details.
- **gitlab** – Helm chart for the GitLab MCP server. See [its README](charts/gitlab/README.md) for usage information.
- **kubernetes** – Helm chart for running the MCP server locally. See [its README](charts/kubernetes/README.md) for details.
- **home-assistant** – Helm chart for deploying the Home Assistant MCP server. See [its README](charts/home-assistant/README.md).
- **docker-mcp** – Helm chart for deploying Docker MCP server. See [its README](charts/docker-mcp/README.md).
- **mcpo** – Helm chart for deploying the mcpo proxy server. See [its README](charts/mcpo/README.md).
- **mcp-library** – Library chart providing common helper templates.

## Development container

A [Dev Container](https://containers.dev/) configuration is provided in the `.devcontainer` directory. It includes Helm and related tools to lint and test the charts locally.
