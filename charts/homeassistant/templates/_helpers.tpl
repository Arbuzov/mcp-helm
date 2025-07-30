{{- define "mcp-homeassistant-helm.name" -}}
{{ include "mcp-library.name" . }}
{{- end }}

{{- define "mcp-homeassistant-helm.fullname" -}}
{{ include "mcp-library.fullname" . }}
{{- end }}

{{- define "mcp-homeassistant-helm.chart" -}}
{{ include "mcp-library.chart" . }}
{{- end }}

{{- define "mcp-homeassistant-helm.labels" -}}
{{ include "mcp-library.labels" . }}
{{- end }}

{{- define "mcp-homeassistant-helm.selectorLabels" -}}
{{ include "mcp-library.selectorLabels" . }}
{{- end }}

{{- define "mcp-homeassistant-helm.serviceAccountName" -}}
{{ include "mcp-library.serviceAccountName" . }}
{{- end }}
