<!-- markdownlint-disable MD013 -->
# Docker MCP Helm Chart

This Helm chart deploys the Docker MCP server based on the `mcp/docker` Docker image to a Kubernetes cluster.

## Prerequisites

- Kubernetes 1.16+
- Helm 3.2.0+

## Installing the Chart

To install the chart with the release name `docker-mcp`:

```bash
helm install docker-mcp ./charts/docker-mcp
```

The command deploys the MCP server on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `docker-mcp` deployment:

```bash
helm delete docker-mcp
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `replicaCount`           | Number of MCP replicas to deploy        | `1`   |
| `nameOverride`           | String to partially override docker-mcp.fullname | `""`  |
| `fullnameOverride`       | String to fully override docker-mcp.fullname   | `""`  |

### Image parameters

| Name                | Description                                          | Value                    |
| ------------------- | ---------------------------------------------------- | ------------------------ |
| `image.repository`  | MCP image repository                          | `mcp/docker` |
| `image.tag`         | MCP image tag (immutable tags are recommended) | `latest`                 |
| `image.pullPolicy`  | MCP image pull policy                         | `IfNotPresent`           |
| `imagePullSecrets`  | MCP image pull secrets                        | `[]`                     |

### Service Account parameters

| Name                         | Description                                                | Value  |
| ---------------------------- | ---------------------------------------------------------- | ------ |
| `serviceAccount.create`      | Specifies whether a service account should be created     | `true` |
| `serviceAccount.annotations` | Annotations to add to the service account                 | `{}`   |
| `serviceAccount.name`        | The name of the service account to use                    | `""`   |

### Service parameters

| Name           | Description                        | Value       |
| -------------- | ---------------------------------- | ----------- |
| `service.type` | MCP service type            | `ClusterIP` |
| `service.port` | MCP service HTTP port       | `8080`      |

### Ingress parameters

| Name                  | Description                                                | Value               |
| --------------------- | ---------------------------------------------------------- | ------------------- |
| `ingress.enabled`     | Enable ingress record generation for MCP          | `false`             |
| `ingress.className`   | IngressClass that will be be used to implement the Ingress | `""`                |
| `ingress.annotations` | Additional annotations for the Ingress resource           | `{}`                |
| `ingress.path` | Base path for the service | `/` |
| `ingress.pathType` | Path matching behavior | `Prefix` |
| `ingress.hosts` | List of hostnames | `["mcp.local"]` |
| `ingress.tls`         | TLS configuration for ingress                             | `[]`                |

### Environment variables

| Name           | Description                                          | Value |
| -------------- | ---------------------------------------------------- | ----- |
| `env`          | Environment variables to be set on the container    | `{}`  |
| `envSecrets`   | Environment variables from external secrets         | `{}`  |
| `secretEnv`    | Environment variables to be set from created secret | `{}`  |

### Autoscaling parameters

| Name                                            | Description                                                                                                          | Value   |
| ----------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- | ------- |
| `autoscaling.enabled`                           | Enable Horizontal Pod Autoscaler (HPA)                                                                              | `false` |
| `autoscaling.minReplicas`                       | Minimum number of MCP replicas                                                                               | `1`     |
| `autoscaling.maxReplicas`                       | Maximum number of MCP replicas                                                                               | `100`   |
| `autoscaling.targetCPUUtilizationPercentage`    | Target CPU utilization percentage                                                                                    | `80`    |
| `autoscaling.targetMemoryUtilizationPercentage` | Target Memory utilization percentage                                                                                 | `""`    |

## Configuration and installation details

### Exposing the application

To access the MCP server from outside the cluster, you can:

1. **Use port forwarding** (for development):

   ```bash
   kubectl port-forward svc/docker-mcp 8080:8080
   ```

2. **Enable ingress** (for production):

   ```yaml
   ingress:
     enabled: true
     className: "nginx"
     path: /
     hosts:
       - docker-mcp.your-domain.com
   ```

3. **Use LoadBalancer service type**:

   ```yaml
   service:
     type: LoadBalancer
   ```

## Troubleshooting

### Check pod status

```bash
kubectl get pods -l app.kubernetes.io/name=docker-mcp-helm
```

### Check logs

```bash
kubectl logs -l app.kubernetes.io/name=docker-mcp-helm
```

### Test connection

```bash
helm test docker-mcp
```
