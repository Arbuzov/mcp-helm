{{- define "mcp-kubernetes-helm.name" -}}
{{ include "mcp-library.name" . }}
{{- end }}

{{- define "mcp-kubernetes-helm.fullname" -}}
{{ include "mcp-library.fullname" . }}
{{- end }}

{{- define "mcp-kubernetes-helm.chart" -}}
{{ include "mcp-library.chart" . }}
{{- end }}

{{- define "mcp-kubernetes-helm.labels" -}}
{{ include "mcp-library.labels" . }}
{{- end }}

{{- define "mcp-kubernetes-helm.selectorLabels" -}}
{{ include "mcp-library.selectorLabels" . }}
{{- end }}

{{- define "mcp-kubernetes-helm.serviceAccountName" -}}
{{ include "mcp-library.serviceAccountName" . }}
{{- end }}
