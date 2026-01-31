# Search Helm Chart

This chart deploys the MCP search crawler together with a companion FlareSolverr
instance. It packages both services in a single release so that they can share
configuration, lifecycle, and network policies when running on Kubernetes.

## Prerequisites

- Kubernetes 1.22+
- Helm 3.9+

## Installation

Install the chart from the repository root:

```bash
helm install search ./charts/search
```

Override configuration values by providing a custom `values.yaml` file or by
setting flags during installation:

```bash
helm install search ./charts/search \
  --set crawler.image.repository=myrepo/crawler \
  --set flaresolverr.image.repository=myrepo/flaresolverr
```

## Configuration

| Parameter | Description | Default |
| --- | --- | --- |
| `replicaCount` | Number of crawler pods to run. | `1` |
| `crawler.image.repository` | Container image for the crawler service. | `laituanmanh/websearch-crawler` |
| `crawler.service.port` | Container port exposed by the crawler. | `8080` |
| `crawler.env` | Key/value environment variables for the crawler container. | `{}` |
| `flaresolverr.image.repository` | Container image for FlareSolverr. | `ghcr.io/flaresolverr/flaresolverr` |
| `flaresolverr.service.port` | Container port exposed by FlareSolverr. | `8191` |
| `service.type` | Kubernetes service type for external access. | `ClusterIP` |
| `service.port` | Service port forwarded to the crawler container. | `80` |
| `ingress.enabled` | Enable Kubernetes ingress resources. | `false` |
| `ingress.hosts` | Host and path rules for ingress routing. | `[{ host: "search.local", paths: [{ path: "/", pathType: "Prefix" }] }]` |
| `config.enabled` | Create a config map and mount it into the pods. | `false` |
| `config.mountPath` | Path where the rendered config map is mounted. | `/etc/config` |
| `customConfig.enabled` | Enable the custom ConfigMap and mount it as a file. | `false` |
| `customConfig.key` | ConfigMap key (file name) to mount. | `custom-config.yaml` |
| `customConfig.mountPath` | Target file path inside the container. | `/etc/mcp/custom-config.yaml` |
| `customConfig.name` | Override name of the custom ConfigMap. | `""` |
| `customConfig.data` | Custom configuration content stored in the ConfigMap. | `""` |
| `secret.data` | Map of base64 encoded secret values exposed to the pods. | `{}` |

Refer to `values.yaml` for the complete list of tunable settings.

## Uninstallation

Remove the release and all associated Kubernetes objects:

```bash
helm uninstall search
```

## License

This project is licensed under the MIT License. See the LICENSE file for details.
