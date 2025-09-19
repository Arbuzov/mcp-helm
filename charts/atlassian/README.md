# mcp-atlassian-helm

![version: 0.2.28](https://img.shields.io/badge/Version-0.2.28-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.16.0](https://img.shields.io/badge/AppVersion-1.16.0-informational?style=flat-square)

A Helm chart for Kubernetes

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| extraArgs | list | `[]` | Additional command line arguments to pass to the container. |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"ghcr.io/sooperset/mcp-atlassian"` |  |
| image.tag | string | `"0.11.9"` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts | list | `["atlassian.local"]` |  |
| ingress.path | string | `/` |  |
| ingress.pathType | string | `ImplementationSpecific` |  |
| ingress.tls | list | `[]` |  |
| livenessProbe.enabled | bool | `true` |  |
| livenessProbe.failureThreshold | int | `3` |  |
| livenessProbe.initialDelaySeconds | int | `60` |  |
| livenessProbe.periodSeconds | int | `30` |  |
| livenessProbe.port | int | `nil` | Override port used by the liveness probe; defaults to `service.port` |
| livenessProbe.timeoutSeconds | int | `10` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| readinessProbe.enabled | bool | `true` |  |
| readinessProbe.failureThreshold | int | `3` |  |
| readinessProbe.initialDelaySeconds | int | `15` |  |
| readinessProbe.periodSeconds | int | `10` |  |
| readinessProbe.port | int | `nil` | Override port used by the readiness probe; defaults to `service.port` |
| readinessProbe.timeoutSeconds | int | `10` |  |
| replicaCount | int | `1` |  |
| resources.limits.cpu | string | `"500m"` |  |
| resources.limits.memory | string | `"512Mi"` |  |
| resources.requests.cpu | string | `"200m"` |  |
| resources.requests.memory | string | `"256Mi"` |  |
| secretEnv | object | `{}` | Create secret with environment data; keys must be valid secret keys and values cannot be empty |
| securityContext | object | `{}` |  |
| service.port | int | `8000` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| sidecars | list | `[]` | Additional sidecar containers |
| tolerations | list | `[]` |  |
| env | object | `{}` | Extra environment variables |
| envSecrets | object | `{}` | Environment variables from secrets |
| secretEnv.data | object | `{}` | Key-value pairs to include in the generated secret |
| secretEnv.name | string | `""` | Name of the generated secret when `secretEnv.data` is set |

When `ingress.path` is not `/`, the annotation `nginx.ingress.kubernetes.io/use-regex: "true"` is automatically added.
