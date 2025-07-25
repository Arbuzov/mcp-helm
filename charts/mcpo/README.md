# mcpo Helm Chart

This Helm chart deploys the [mcpo](https://github.com/open-webui/mcpo) proxy server based on the `ghcr.io/open-webui/mcpo` Docker image to a Kubernetes cluster.

## Prerequisites

- Kubernetes 1.16+
- Helm 3.2.0+

## Installing the Chart

To install the chart with the release name `mcpo`:

```bash
helm install mcpo ./charts/mcpo
```

The command deploys the mcpo proxy on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

## Uninstalling the Chart

To uninstall/delete the `mcpo` deployment:

```bash
helm delete mcpo
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                | Description                                   | Value |
| ------------------- | --------------------------------------------- | ----- |
| `replicaCount`      | Number of mcpo replicas to deploy             | `1`   |
| `nameOverride`      | String to partially override mcpo.fullname    | `""`  |
| `fullnameOverride`  | String to fully override mcpo.fullname        | `""`  |

### Image parameters

| Name               | Description                                | Value                        |
| ------------------ | ------------------------------------------ | ---------------------------- |
| `image.repository` | mcpo image repository                      | `ghcr.io/open-webui/mcpo`    |
| `image.tag`        | mcpo image tag (immutable tags recommended) | `main`                       |
| `image.pullPolicy` | mcpo image pull policy                     | `IfNotPresent`               |
| `imagePullSecrets` | mcpo image pull secrets                    | `[]`                         |

### Service Account parameters

| Name                         | Description                             | Value |
| ---------------------------- | --------------------------------------- | ----- |
| `serviceAccount.create`      | Specifies whether a service account should be created | `true` |
| `serviceAccount.annotations` | Annotations to add to the service account | `{}`   |
| `serviceAccount.name`        | The name of the service account to use | `""`   |

### Service parameters

| Name           | Description             | Value       |
| -------------- | ----------------------- | ----------- |
| `service.type` | mcpo service type       | `ClusterIP` |
| `service.port` | mcpo service HTTP port  | `8080`      |

### Ingress parameters

| Name                  | Description                                              | Value |
| --------------------- | -------------------------------------------------------- | ----- |
| `ingress.enabled`     | Enable ingress record generation for mcpo                | `false` |
| `ingress.className`   | IngressClass that will be used to implement the Ingress   | `""`    |
| `ingress.annotations` | Additional annotations for the Ingress resource          | `{}`    |
| `ingress.hosts`       | An array with hosts and paths                             | `[{host: "mcpo.local", paths: [{path: "/", pathType: "Prefix"}]}]` |
| `ingress.tls`         | TLS configuration for ingress                             | `[]`    |

### Environment variables

| Name         | Description                                          | Value |
| ------------ | ---------------------------------------------------- | ----- |
| `env`        | Environment variables to be set on the container    | `{}`  |
| `envSecrets` | Environment variables from external secrets         | `{}`  |
| `secretEnv`  | Environment variables to be set from created secret | `{}`  |

### Autoscaling parameters

| Name                                            | Description                              | Value |
| ----------------------------------------------- | ---------------------------------------- | ----- |
| `autoscaling.enabled`                           | Enable Horizontal Pod Autoscaler (HPA)   | `false` |
| `autoscaling.minReplicas`                       | Minimum number of mcpo replicas          | `1` |
| `autoscaling.maxReplicas`                       | Maximum number of mcpo replicas          | `100` |
| `autoscaling.targetCPUUtilizationPercentage`    | Target CPU utilization percentage        | `80` |
| `autoscaling.targetMemoryUtilizationPercentage` | Target Memory utilization percentage     | `""` |

## Configuration and installation details

mcpo proxies another MCP server. Supply the command to run after `--` using `env` or a configuration file mounted as a volume and referenced with `--config`.

### Exposing the application

To access the mcpo server from outside the cluster, you can:

1. **Use port forwarding** (for development):

   ```bash
   kubectl port-forward svc/mcpo 8080:8080
   ```

2. **Enable ingress** (for production):

   ```yaml
   ingress:
     enabled: true
     className: "nginx"
     hosts:
       - host: mcpo.your-domain.com
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
kubectl get pods -l app.kubernetes.io/name=mcp-mcpo-helm
```

### Check logs

```bash
kubectl logs -l app.kubernetes.io/name=mcp-mcpo-helm
```

### Test connection

```bash
helm test mcpo
```
