# Home Assistant MCP Helm Chart

This Helm chart deploys the Home Assistant MCP (Model Context Protocol) server based on the `voska/hass-mcp` Docker image to a Kubernetes cluster.

## Prerequisites

- Kubernetes 1.16+
- Helm 3.2.0+

## Installing the Chart

To install the chart with the release name `hass-mcp`:

```bash
helm install hass-mcp ./charts/home-assistant
```

The command deploys the Home Assistant MCP server on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `hass-mcp` deployment:

```bash
helm delete hass-mcp
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `replicaCount`           | Number of Home Assistant MCP replicas to deploy        | `1`   |
| `nameOverride`           | String to partially override hass-mcp.fullname | `""`  |
| `fullnameOverride`       | String to fully override hass-mcp.fullname   | `""`  |

### Image parameters

| Name                | Description                                          | Value                    |
| ------------------- | ---------------------------------------------------- | ------------------------ |
| `image.repository`  | Home Assistant MCP image repository                          | `voska/hass-mcp` |
| `image.tag`         | Home Assistant MCP image tag (immutable tags are recommended) | `latest`                 |
| `image.pullPolicy`  | Home Assistant MCP image pull policy                         | `IfNotPresent`           |
| `imagePullSecrets`  | Home Assistant MCP image pull secrets                        | `[]`                     |

### Service Account parameters

| Name                         | Description                                                | Value  |
| ---------------------------- | ---------------------------------------------------------- | ------ |
| `serviceAccount.create`      | Specifies whether a service account should be created     | `true` |
| `serviceAccount.annotations` | Annotations to add to the service account                 | `{}`   |
| `serviceAccount.name`        | The name of the service account to use                    | `""`   |

### Service parameters

| Name           | Description                        | Value       |
| -------------- | ---------------------------------- | ----------- |
| `service.type` | Home Assistant MCP service type            | `ClusterIP` |
| `service.port` | Home Assistant MCP service HTTP port       | `8080`      |

### Ingress parameters

| Name                  | Description                                                | Value               |
| --------------------- | ---------------------------------------------------------- | ------------------- |
| `ingress.enabled`     | Enable ingress record generation for Home Assistant MCP          | `false`             |
| `ingress.className`   | IngressClass that will be be used to implement the Ingress | `""`                |
| `ingress.annotations` | Additional annotations for the Ingress resource           | `{}`                |
| `ingress.hosts`       | An array with hosts and paths                             | `[{host: "hass-mcp.local", paths: [{path: "/", pathType: "Prefix"}]}]` |
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
| `autoscaling.minReplicas`                       | Minimum number of Home Assistant MCP replicas                                                                               | `1`     |
| `autoscaling.maxReplicas`                       | Maximum number of Home Assistant MCP replicas                                                                               | `100`   |
| `autoscaling.targetCPUUtilizationPercentage`    | Target CPU utilization percentage                                                                                    | `80`    |
| `autoscaling.targetMemoryUtilizationPercentage` | Target Memory utilization percentage                                                                                 | `""`    |

## Configuration and installation details

### Setting up Home Assistant access

The Home Assistant MCP server requires access to your Home Assistant instance. You can configure this using environment variables:

1. **Using plain environment variables** (not recommended for production):

   ```yaml
   env:
     HA_URL: "http://homeassistant.local:8123"
     HA_TOKEN: "your-long-lived-access-token"
   ```

2. **Using secrets** (recommended for production):

   ```yaml
   secretEnv:
     data:
       HA_TOKEN: "your-long-lived-access-token"
   env:
     HA_URL: "http://homeassistant.local:8123"
   ```

### Exposing the application

To access the Home Assistant MCP server from outside the cluster, you can:

1. **Use port forwarding** (for development):

   ```bash
   kubectl port-forward svc/hass-mcp 8080:8080
   ```

2. **Enable ingress** (for production):

   ```yaml
   ingress:
     enabled: true
     className: "nginx"
     hosts:
       - host: hass-mcp.your-domain.com
         paths:
           - path: /
             pathType: Prefix
   ```

3. **Use LoadBalancer service type**:

   ```yaml
   service:
     type: LoadBalancer
   ```

## Troubleshooting

### Check pod status

```bash
kubectl get pods -l app.kubernetes.io/name=mcp-home-assistant-helm
```

### Check logs

```bash
kubectl logs -l app.kubernetes.io/name=mcp-home-assistant-helm
```

### Test connection

```bash
helm test hass-mcp
```
