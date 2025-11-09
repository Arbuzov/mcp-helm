{{- define "mcp-copilot-api-helm.name" -}}
{{ include "mcp-library.name" . }}
{{- end }}

{{- define "mcp-copilot-api-helm.fullname" -}}
{{ include "mcp-library.fullname" . }}
{{- end }}

{{- define "mcp-copilot-api-helm.chart" -}}
{{ include "mcp-library.chart" . }}
{{- end }}

{{- define "mcp-copilot-api-helm.labels" -}}
{{ include "mcp-library.labels" . }}
{{- end }}

{{- define "mcp-copilot-api-helm.selectorLabels" -}}
{{ include "mcp-library.selectorLabels" . }}
{{- end }}

{{- define "mcp-copilot-api-helm.serviceAccountName" -}}
{{ include "mcp-library.serviceAccountName" . }}
{{- end }}

{{- define "mcp-copilot-api-helm.tokenSecretName" -}}
{{- if .Values.auth.tokenSecret.existingSecret -}}
{{ .Values.auth.tokenSecret.existingSecret }}
{{- else -}}
{{- default (printf "%s-token" (include "mcp-copilot-api-helm.fullname" .)) .Values.auth.tokenSecret.name -}}
{{- end -}}
{{- end }}

{{- define "mcp-copilot-api-helm.tokenSecretKey" -}}
{{- if and .Values.auth.tokenSecret.existingSecret .Values.auth.tokenSecret.existingSecretKey -}}
{{ .Values.auth.tokenSecret.existingSecretKey }}
{{- else -}}
{{- default "GH_TOKEN" .Values.auth.tokenSecret.key -}}
{{- end -}}
{{- end }}
