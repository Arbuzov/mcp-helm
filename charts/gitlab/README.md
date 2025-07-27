# GitLab MCP Helm Chart

This Helm chart deploys the GitLab MCP (Model Context Protocol) server based on the `iwakitakuma/gitlab-mcp` Docker image to a Kubernetes cluster.

## Prerequisites

- Kubernetes 1.16+
- Helm 3.2.0+

## Installing the Chart

To install the chart with the release name `gitlab-mcp`:

```bash
helm install gitlab-mcp ./charts/gitlab
```

The command deploys the GitLab MCP server on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `gitlab-mcp` deployment:

```bash
helm delete gitlab-mcp
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `replicaCount`           | Number of GitLab MCP replicas to deploy        | `1`   |
| `nameOverride`           | String to partially override gitlab-mcp.fullname | `""`  |
| `fullnameOverride`       | String to fully override gitlab-mcp.fullname   | `""`  |

### Image parameters

| Name                | Description                                          | Value                    |
| ------------------- | ---------------------------------------------------- | ------------------------ |
| `image.repository`  | GitLab MCP image repository                          | `iwakitakuma/gitlab-mcp` |
| `image.tag`         | GitLab MCP image tag (immutable tags are recommended) | `latest`                 |
| `image.pullPolicy`  | GitLab MCP image pull policy                         | `IfNotPresent`           |
| `imagePullSecrets`  | GitLab MCP image pull secrets                        | `[]`                     |

### Service Account parameters

| Name                         | Description                                                | Value  |
| ---------------------------- | ---------------------------------------------------------- | ------ |
| `serviceAccount.create`      | Specifies whether a service account should be created     | `true` |
| `serviceAccount.annotations` | Annotations to add to the service account                 | `{}`   |
| `serviceAccount.name`        | The name of the service account to use                    | `""`   |

### Service parameters

| Name           | Description                        | Value       |
| -------------- | ---------------------------------- | ----------- |
| `service.type` | GitLab MCP service type            | `ClusterIP` |
| `service.port` | GitLab MCP service HTTP port       | `8080`      |

### Ingress parameters

| Name                  | Description                                                | Value               |
| --------------------- | ---------------------------------------------------------- | ------------------- |
| `ingress.enabled`     | Enable ingress record generation for GitLab MCP          | `false`             |
| `ingress.className`   | IngressClass that will be be used to implement the Ingress | `""`                |
| `ingress.annotations` | Additional annotations for the Ingress resource           | `{}`                |
| `ingress.path` | Base path for the service | `/` |
| `ingress.pathType` | Path matching behavior | `Prefix` |
| `ingress.hosts` | List of hostnames | `["gitlab-mcp.local"]` |
| `ingress.tls`         | TLS configuration for ingress            | `[]`                |

When `ingress.path` is not `/`, the annotation `nginx.ingress.kubernetes.io/use-regex: "true"` is automatically added.

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
| `autoscaling.minReplicas`                       | Minimum number of GitLab MCP replicas                                                                               | `1`     |
| `autoscaling.maxReplicas`                       | Maximum number of GitLab MCP replicas                                                                               | `100`   |
| `autoscaling.targetCPUUtilizationPercentage`    | Target CPU utilization percentage                                                                                    | `80`    |
| `autoscaling.targetMemoryUtilizationPercentage` | Target Memory utilization percentage                                                                                 | `""`    |

## Configuration and installation details

### Setting up GitLab access

The GitLab MCP server requires access to GitLab. You can configure this using environment variables:

1. **Using plain environment variables** (not recommended for production):

   ```yaml
   env:
     GITLAB_URL: "https://gitlab.com"
     GITLAB_TOKEN: "your-gitlab-token"
   ```

2. **Using secrets** (recommended for production):

   ```yaml
   secretEnv:
     data:
       GITLAB_TOKEN: "your-gitlab-token"
   env:
     GITLAB_URL: "https://gitlab.com"
   ```

### Exposing the application

To access the GitLab MCP server from outside the cluster, you can:

1. **Use port forwarding** (for development):

   ```bash
   kubectl port-forward svc/gitlab-mcp 8080:8080
   ```

2. **Enable ingress** (for production):

   ```yaml
   ingress:
     enabled: true
     className: "nginx"
     path: /
     hosts:
       - gitlab-mcp.your-domain.com
   ```

3. **Use LoadBalancer service type**:

   ```yaml
   service:
     type: LoadBalancer
   ```

## Troubleshooting

### Check pod status

```bash
kubectl get pods -l app.kubernetes.io/name=mcp-gitlab-helm
```

### Check logs

```bash
kubectl logs -l app.kubernetes.io/name=mcp-gitlab-helm
```

### Test connection

```bash
helm test gitlab-mcp
```
