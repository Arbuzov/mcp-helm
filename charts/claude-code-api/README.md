# Claude Code API Helm Chart

This Helm chart deploys the [Claude Code API gateway](https://github.com/cabinlab/claude-code-api), an OpenAI-compatible interface for Claude Code with built-in admin UI for exchanging OAuth tokens for API keys.

## Prerequisites

- Kubernetes 1.26+
- Helm 3.12+

## Installing the Chart

To install the chart with the release name `claude-code-api`:

```bash
helm install claude-code-api ./charts/claude-code-api \
  --set "auth.claudeOAuthToken.value=sk-ant-oat01-..." \
  --set "auth.adminPassword.value=super-secret"
```

The command deploys the API gateway and stores the provided credentials in a managed Kubernetes secret. See [Parameters](#parameters) for the full list of configurable options.

## Uninstalling the Chart

To uninstall/delete the `claude-code-api` deployment:

```bash
helm delete claude-code-api
```

## Parameters

### Global parameters

| Name | Description | Value |
| --- | --- | --- |
| `replicaCount` | Number of replicas to deploy | `1` |
| `nameOverride` | String to partially override `claude-code-api.fullname` | `""` |
| `fullnameOverride` | String to fully override `claude-code-api.fullname` | `""` |

### Image parameters

| Name | Description | Value |
| --- | --- | --- |
| `image.repository` | Container image repository | `ghcr.io/cabinlab/claude-code-api` |
| `image.tag` | Container image tag (defaults to chart `appVersion` when empty) | `""` |
| `image.pullPolicy` | Container image pull policy | `IfNotPresent` |
| `imagePullSecrets` | Kubernetes image pull secrets | `[]` |

### Service account parameters

| Name | Description | Value |
| --- | --- | --- |
| `serviceAccount.create` | Specifies whether a service account should be created | `true` |
| `serviceAccount.annotations` | Annotations to add to the service account | `{}` |
| `serviceAccount.name` | Name of the service account to use | `""` |

### Service parameters

| Name | Description | Value |
| --- | --- | --- |
| `service.type` | Kubernetes service type | `ClusterIP` |
| `service.ports.http.port` | Service port for the HTTP API | `8000` |
| `service.ports.http.targetPort` | Container port for the HTTP API | `8000` |
| `service.ports.https.enabled` | Expose the HTTPS admin port through the service | `true` |
| `service.ports.https.port` | Service port for the HTTPS admin UI | `8443` |
| `service.ports.https.targetPort` | Container port for the HTTPS admin UI | `8443` |

### Ingress parameters

| Name | Description | Value |
| --- | --- | --- |
| `ingress.enabled` | Enable ingress resource | `false` |
| `ingress.className` | IngressClass used to implement the Ingress | `""` |
| `ingress.annotations` | Additional annotations for the Ingress | `{}` |
| `ingress.path` | Base path for the ingress | `/` |
| `ingress.pathType` | Path matching behavior | `Prefix` |
| `ingress.hosts` | Hostnames for the ingress | `["claude-code-api.local"]` |
| `ingress.tls` | TLS configuration | `[]` |

### Application parameters

| Name | Description | Value |
| --- | --- | --- |
| `app.port` | HTTP API port inside the container | `8000` |
| `app.httpsPort` | HTTPS admin port inside the container | `8443` |
| `app.nodeEnv` | `NODE_ENV` value for the service | `production` |
| `app.logLevel` | `LOG_LEVEL` value for the service | `info` |

### Authentication parameters

| Name | Description | Value |
| --- | --- | --- |
| `auth.secret.create` | Create and manage a Kubernetes secret for credentials | `true` |
| `auth.secret.name` | Override name for the managed secret | `""` |
| `auth.secret.annotations` | Extra annotations for the managed secret | `{}` |
| `auth.adminPassword.key` | Environment variable key for the admin password | `ADMIN_PASSWORD` |
| `auth.adminPassword.value` | **Plaintext** admin password stored in the managed secret | `changeme` |
| `auth.adminPassword.valueBase64` | Base64-encoded admin password stored verbatim in the managed secret | `""` |
| `auth.adminPassword.existingSecret` | Existing secret to read the admin password from | `""` |
| `auth.adminPassword.existingSecretKey` | Key inside the existing admin secret | `ADMIN_PASSWORD` |
| `auth.claudeOAuthToken.key` | Environment variable key for the Claude OAuth token | `CLAUDE_CODE_OAUTH_TOKEN` |
| `auth.claudeOAuthToken.value` | **Plaintext** Claude OAuth token stored in the managed secret | `""` |
| `auth.claudeOAuthToken.valueBase64` | Base64-encoded Claude OAuth token stored verbatim in the managed secret | `""` |
| `auth.claudeOAuthToken.existingSecret` | Existing secret to read the Claude OAuth token from | `""` |
| `auth.claudeOAuthToken.existingSecretKey` | Key inside the existing Claude OAuth secret | `CLAUDE_CODE_OAUTH_TOKEN` |

### Environment parameters

| Name | Description | Value |
| --- | --- | --- |
| `env` | Additional environment variables for the container | `{}` |
| `envSecrets` | Environment variables sourced from external secrets | `{}` |
| `secretEnv.data` | Additional key/value pairs stored in a dedicated secret and exposed as environment variables | `{}` |

### Autoscaling parameters

| Name | Description | Value |
| --- | --- | --- |
| `autoscaling.enabled` | Enable Horizontal Pod Autoscaler | `false` |
| `autoscaling.minReplicas` | Minimum number of replicas | `1` |
| `autoscaling.maxReplicas` | Maximum number of replicas | `100` |
| `autoscaling.targetCPUUtilizationPercentage` | Target CPU utilization percentage | `80` |
| `autoscaling.targetMemoryUtilizationPercentage` | Target memory utilization percentage | `""` |

### Resource parameters

| Name | Description | Value |
| --- | --- | --- |
| `resources` | Resource requests and limits for the pod | `{}` |

## Configuration and installation details

### Providing the Claude OAuth token and admin password

The service requires both an admin password for the management UI and a Claude OAuth token used to generate client API keys. Provide these values via `auth.*` settings. By default the chart creates a secret named `<release>-auth` and writes the supplied credentials into it. To reuse an existing secret, set `auth.secret.create=false` and configure `auth.adminPassword.existingSecret` and `auth.claudeOAuthToken.existingSecret` with the appropriate keys.

When setting `*.value`, supply the **plaintext** credential; the chart encodes it before writing to the Kubernetes Secret. To supply a pre-encoded value, use the corresponding `*.valueBase64` setting instead.

### Exposing the service

Enable ingress by setting `ingress.enabled=true` and configure `ingress.hosts` and TLS as needed. The service listens on port `8000` for the OpenAI-compatible API and `8443` for the admin UI.
