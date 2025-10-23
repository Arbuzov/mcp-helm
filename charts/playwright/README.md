# Playwright MCP Helm Chart

This Helm chart deploys the Playwright MCP (Model Context Protocol) server using the
`mcr.microsoft.com/playwright/mcp` container image. The chart runs the server in headless
Chromium mode and exposes the SSE transport so MCP clients can connect over HTTP.

## Prerequisites

- Kubernetes 1.16+
- Helm 3.2.0+

## Installing the Chart

To install the chart with the release name `mcp-playwright`:

```bash
helm install mcp-playwright ./charts/playwright
```

The command deploys the Playwright MCP server on the Kubernetes cluster with the default
configuration. The [Parameters](#parameters) section lists the configuration values you
can override during installation.

## Uninstalling the Chart

To uninstall/delete the `mcp-playwright` deployment:

```bash
helm delete mcp-playwright
```

The command removes all Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                | Description                                                     | Value |
| ------------------- | --------------------------------------------------------------- | ----- |
| `replicaCount`      | Number of MCP replicas to deploy                                | `1`   |
| `nameOverride`      | String to partially override `mcp-playwright.fullname`          | `""`  |
| `fullnameOverride`  | String to fully override `mcp-playwright.fullname`              | `""`  |

### Image parameters

| Name               | Description                                          | Value                               |
| ------------------ | ---------------------------------------------------- | ----------------------------------- |
| `image.repository` | MCP image repository                                 | `mcr.microsoft.com/playwright/mcp`  |
| `image.tag`        | MCP image tag (immutable tags are recommended)       | `v0.0.43`                           |
| `image.pullPolicy` | MCP image pull policy                                | `IfNotPresent`                      |
| `imagePullSecrets` | MCP image pull secrets                               | `[]`                                |

### Service Account parameters

| Name                         | Description                                                | Value  |
| ---------------------------- | ---------------------------------------------------------- | ------ |
| `serviceAccount.create`      | Specifies whether a service account should be created     | `true` |
| `serviceAccount.annotations` | Annotations to add to the service account                 | `{}`   |
| `serviceAccount.name`        | The name of the service account to use                    | `""`   |

### Service parameters

| Name             | Description                               | Value       |
| ---------------- | ----------------------------------------- | ----------- |
| `service.type`   | Kubernetes service type                   | `ClusterIP` |
| `service.port`   | Service port that exposes the MCP server  | `8931`      |
| `service.targetPort` | Container port the MCP server listens on | `8931`  |

### Ingress parameters

| Name                  | Description                                                | Value               |
| --------------------- | ---------------------------------------------------------- | ------------------- |
| `ingress.enabled`     | Enable ingress record generation for the MCP server        | `false`             |
| `ingress.className`   | IngressClass used to implement the Ingress                 | `""`                |
| `ingress.annotations` | Additional annotations for the Ingress resource            | `{}`                |
| `ingress.path`        | Base path for the service                                  | `/`                 |
| `ingress.pathType`    | Path matching behavior                                     | `Prefix`            |
| `ingress.hosts`       | List of hostnames                                          | `["playwright.local"]` |
| `ingress.tls`         | TLS configuration for ingress                              | `[]`                |

When `ingress.path` is not `/`, the annotation `nginx.ingress.kubernetes.io/use-regex: "true"` is automatically added.

When you set an ingress host to `"*"`, the chart omits the `host` field from the generated
Ingress rule so that controllers that support wildcard routing (for example, NGINX) can
match any hostname. Some ingress controllers may require explicit hostnames instead.

### Environment variables

| Name         | Description                                          | Value |
| ------------ | ---------------------------------------------------- | ----- |
| `env`        | Environment variables to set on the container        | `{}`  |
| `envSecrets` | Environment variables sourced from existing secrets  | `{}`  |
| `secretEnv`  | Environment variables to create from chart-managed secret | `{}` |

> [!IMPORTANT]
> The `secretEnv` section is intended for quick experiments only. For production
> deployments, prefer sourcing sensitive data from existing Kubernetes Secrets (via
> `envSecrets`) or from an external secret manager to avoid storing credentials in
> plaintext values files.

### Command line arguments

| Name          | Description                                                        | Value |
| ------------- | ------------------------------------------------------------------ | ----- |
| `extraArgs`   | Additional CLI arguments appended after the automatically managed port and path flags | `[]` |

### Autoscaling parameters

| Name                                            | Description                                         | Value |
| ----------------------------------------------- | --------------------------------------------------- | ----- |
| `autoscaling.enabled`                           | Enable Horizontal Pod Autoscaler (HPA)              | `false` |
| `autoscaling.minReplicas`                       | Minimum number of MCP replicas                      | `1`   |
| `autoscaling.maxReplicas`                       | Maximum number of MCP replicas                      | `100` |
| `autoscaling.targetCPUUtilizationPercentage`    | Target CPU utilization percentage                   | `80`  |
| `autoscaling.targetMemoryUtilizationPercentage` | Target Memory utilization percentage                | `""` |

## Configuration and installation details

### Exposing the application

The container entrypoint already launches the server in headless Chromium mode. The chart
passes the configured service port to the server so it listens for HTTP connections. To
make the MCP server reachable from outside the cluster, you can:

1. **Use port forwarding** during development:

   ```bash
   kubectl port-forward svc/mcp-playwright 8931:8931
   ```

2. **Enable ingress** for production traffic:

   ```yaml
   ingress:
     enabled: true
     className: "nginx"
     hosts:
       - playwright.your-domain.com
   ```

3. **Switch to the LoadBalancer service type** when your cluster supports it:

   ```yaml
   service:
     type: LoadBalancer
   ```

## Troubleshooting

### Check pod status

```bash
kubectl get pods -l app.kubernetes.io/name=mcp-playwright
```

### Check logs

```bash
kubectl logs -l app.kubernetes.io/name=mcp-playwright
```

### Test connection

```bash
helm test mcp-playwright
```
