{{- define "mcp-mcpo-helm.name" -}}
{{ include "mcp-library.name" . }}
{{- end }}

{{- define "mcp-mcpo-helm.fullname" -}}
{{ include "mcp-library.fullname" . }}
{{- end }}

{{- define "mcp-mcpo-helm.chart" -}}
{{ include "mcp-library.chart" . }}
{{- end }}

{{- define "mcp-mcpo-helm.labels" -}}
{{ include "mcp-library.labels" . }}
{{- end }}

{{- define "mcp-mcpo-helm.selectorLabels" -}}
{{ include "mcp-library.selectorLabels" . }}
{{- end }}

{{- define "mcp-mcpo-helm.serviceAccountName" -}}
{{ include "mcp-library.serviceAccountName" . }}
{{- end }}

{{/* Render mcpo configuration as pretty JSON */}}
{{- define "mcp-mcpo-helm.config" -}}
{{- .Values.config | toPrettyJson }}
{{- end }}
