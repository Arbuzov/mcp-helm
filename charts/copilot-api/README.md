# Copilot API Helm Chart

This Helm chart deploys the [`nghyane/copilot-api`](https://hub.docker.com/r/nghyane/copilot-api) proxy, a wrapper around the GitHub Copilot API that exposes an OpenAI-compatible interface.

## Prerequisites

- Kubernetes 1.16+
- Helm 3.2.0+

## Installing the Chart

To install the chart with the release name `copilot-api`:

```bash
helm install copilot-api ./charts/copilot-api \
  --set "auth.tokenSecret.value=ghp_your_token"
```

The command deploys the Copilot API proxy on the Kubernetes cluster with a GitHub token stored in a generated secret. The [Parameters](#parameters) section lists the configurable parameters.

## Uninstalling the Chart

To uninstall/delete the `copilot-api` deployment:

```bash
helm delete copilot-api
```

## Parameters

### Global parameters

| Name               | Description                                                  | Value |
| ------------------ | ------------------------------------------------------------ | ----- |
| `replicaCount`     | Number of replicas to deploy                                 | `1`   |
| `nameOverride`     | String to partially override `copilot-api.fullname`          | `""` |
| `fullnameOverride` | String to fully override `copilot-api.fullname`              | `""` |

### Image parameters

| Name               | Description                                         | Value                  |
| ------------------ | --------------------------------------------------- | ---------------------- |
| `image.repository` | Container image repository                         | `nghyane/copilot-api`  |
| `image.tag`        | Container image tag (immutable tags are preferred) | `latest`               |
| `image.pullPolicy` | Container image pull policy                        | `IfNotPresent`         |
| `imagePullSecrets` | Kubernetes image pull secrets                      | `[]`                   |

### Service account parameters

| Name                         | Description                                         | Value  |
| ---------------------------- | --------------------------------------------------- | ------ |
| `serviceAccount.create`      | Specifies whether a service account should be created | `true` |
| `serviceAccount.annotations` | Annotations to add to the service account             | `{}`   |
| `serviceAccount.name`        | Name of the service account to use                    | `""`   |

### Service parameters

| Name                 | Description                            | Value       |
| -------------------- | -------------------------------------- | ----------- |
| `service.type`       | Kubernetes service type                | `ClusterIP` |
| `service.port`       | Service port                           | `4141`      |
| `service.targetPort` | Container port exposed by the service | `4141`      |

### Ingress parameters

| Name                  | Description                                                | Value               |
| --------------------- | ---------------------------------------------------------- | ------------------- |
| `ingress.enabled`     | Enable ingress resource                                    | `false`             |
| `ingress.className`   | IngressClass used to implement the Ingress                 | `""`                |
| `ingress.annotations` | Additional annotations for the Ingress                     | `{}`                |
| `ingress.path`        | Base path for the ingress                                  | `/`                 |
| `ingress.pathType`    | Path matching behavior                                     | `Prefix`            |
| `ingress.hosts`       | Hostnames for the ingress                                  | `["copilot-api.local"]` |
| `ingress.tls`         | TLS configuration                                          | `[]`                |

When `ingress.path` differs from `/`, the annotation `nginx.ingress.kubernetes.io/use-regex: "true"` is added automatically.

### Authentication parameters

| Name                                   | Description                                                                                                  | Value |
| -------------------------------------- | ------------------------------------------------------------------------------------------------------------ | ----- |
| `auth.tokenSecret.create`              | Create and manage a Kubernetes secret containing the GitHub token                        | `true` |
| `auth.tokenSecret.name`                | Override name for the managed secret                        | `""`  |
| `auth.tokenSecret.key`                 | Key used inside the managed secret                        | `GH_TOKEN` |
| `auth.tokenSecret.value`               | **Plaintext** GitHub token stored in the managed secret (set via `--set` or as a secret value)          | `""`  |
| `auth.tokenSecret.valueBase64`         | Base64-encoded GitHub token stored verbatim in the managed secret                                       | `""`  |
| `auth.tokenSecret.generate`            | Generate a random token when no value is provided (keeps existing value on upgrades)                        | `false` |
| `auth.tokenSecret.reuseExisting`       | Reuse a previously created secret value on upgrades (requires cluster access for the `lookup` helper)   | `true` |
| `auth.tokenSecret.existingSecret`      | Use an existing secret instead of creating one                        | `""`  |
| `auth.tokenSecret.existingSecretKey`   | Key inside the existing secret that stores the GitHub token                        | `""`  |
| `auth.tokenSecret.annotations`         | Extra annotations for the managed secret                        | `{}`   |

Exactly one of `auth.tokenSecret.value`, `auth.tokenSecret.valueBase64`, `auth.tokenSecret.generate`, or `auth.tokenSecret.existingSecret` must be set to supply a valid GitHub token.

### Environment parameters

| Name            | Description                                                  | Value |
| --------------- | ------------------------------------------------------------ | ----- |
| `env`           | Additional environment variables for the container           | `{}`  |
| `envSecrets`    | Environment variables sourced from external secrets          | `{}`  |
| `secretEnv`     | Additional key/value pairs stored in a dedicated secret and exposed as environment variables | `{}` |

### Autoscaling parameters

| Name                                            | Description                                         | Value |
| ----------------------------------------------- | --------------------------------------------------- | ----- |
| `autoscaling.enabled`                           | Enable Horizontal Pod Autoscaler                   | `false` |
| `autoscaling.minReplicas`                       | Minimum number of replicas                          | `1` |
| `autoscaling.maxReplicas`                       | Maximum number of replicas                          | `100` |
| `autoscaling.targetCPUUtilizationPercentage`    | Target CPU utilization percentage                   | `80` |
| `autoscaling.targetMemoryUtilizationPercentage` | Target memory utilization percentage                | `""` |

### Resource parameters

| Name        | Description                                | Value |
| ----------- | ------------------------------------------ | ----- |
| `resources` | Resource requests and limits for the pod   | `{}`  |

## Configuration and installation details

### Providing the GitHub token

The Copilot API proxy requires a GitHub token with Copilot access. By default the chart creates a secret named `<release>-copilot-api-token` that stores the value provided via `auth.tokenSecret.value`. To avoid storing the token in plaintext in your values file, supply it at install time:

```bash
helm install copilot-api ./charts/copilot-api \
  --set-file auth.tokenSecret.value=./secrets/github-token.txt
```

Alternatively, reuse an existing secret:

```bash
helm install copilot-api ./charts/copilot-api \
  --set auth.tokenSecret.create=false \
  --set auth.tokenSecret.existingSecret=copilot-token \
  --set auth.tokenSecret.existingSecretKey=GH_TOKEN
```

On upgrades the chart reuses the previously stored token by default so that the value is not regenerated or overwritten. This behaviour relies on Helm's [`lookup`](https://helm.sh/docs/chart_template_guide/functions_and_pipelines/#using-the-lookup-function) helper and therefore requires Helm 3 with live cluster connectivity. When rendering templates offline (for example via `helm template` in CI), set `auth.tokenSecret.reuseExisting=false` and provide the token explicitly.

When setting `auth.tokenSecret.value`, provide the **plaintext** token; the chart encodes it before writing to the Kubernetes Secret. To supply a pre-encoded value, use `auth.tokenSecret.valueBase64` instead.

### Exposing the service

Enable ingress by setting `ingress.enabled=true` and configure `ingress.hosts` and TLS as needed. The service listens on port `4141`, matching the default Copilot API port.

### Adding additional secret environment variables

Keys defined under `secretEnv.data` must follow standard environment variable naming rules (`^[A-Za-z_][A-Za-z0-9_]*$`). Invalid keys will cause chart rendering to fail to prevent generating unusable Kubernetes secrets.
