{{- define "mcp-gitlab-helm.name" -}}
{{ include "mcp-library.name" . }}
{{- end }}

{{- define "mcp-gitlab-helm.fullname" -}}
{{ include "mcp-library.fullname" . }}
{{- end }}

{{- define "mcp-gitlab-helm.chart" -}}
{{ include "mcp-library.chart" . }}
{{- end }}

{{- define "mcp-gitlab-helm.labels" -}}
{{ include "mcp-library.labels" . }}
{{- end }}

{{- define "mcp-gitlab-helm.selectorLabels" -}}
{{ include "mcp-library.selectorLabels" . }}
{{- end }}

{{- define "mcp-gitlab-helm.serviceAccountName" -}}
{{ include "mcp-library.serviceAccountName" . }}
{{- end }}
