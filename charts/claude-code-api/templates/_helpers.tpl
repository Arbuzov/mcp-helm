{{- define "claude-code-api-helm.name" -}}
{{ include "mcp-library.name" . }}
{{- end }}

{{- define "claude-code-api-helm.fullname" -}}
{{ include "mcp-library.fullname" . }}
{{- end }}

{{- define "claude-code-api-helm.chart" -}}
{{ include "mcp-library.chart" . }}
{{- end }}

{{- define "claude-code-api-helm.labels" -}}
{{ include "mcp-library.labels" . }}
{{- end }}

{{- define "claude-code-api-helm.selectorLabels" -}}
{{ include "mcp-library.selectorLabels" . }}
{{- end }}

{{- define "claude-code-api-helm.serviceAccountName" -}}
{{ include "mcp-library.serviceAccountName" . }}
{{- end }}

{{- define "claude-code-api-helm.authSecretName" -}}
{{- if .Values.auth.secret.name -}}
{{ .Values.auth.secret.name }}
{{- else -}}
{{ printf "%s-auth" (include "claude-code-api-helm.fullname" .) }}
{{- end -}}
{{- end }}

{{- define "claude-code-api-helm.adminSecretName" -}}
{{- if .Values.auth.adminPassword.existingSecret -}}
{{ .Values.auth.adminPassword.existingSecret }}
{{- else -}}
{{ include "claude-code-api-helm.authSecretName" . }}
{{- end -}}
{{- end }}

{{- define "claude-code-api-helm.tokenSecretName" -}}
{{- if .Values.auth.claudeOAuthToken.existingSecret -}}
{{ .Values.auth.claudeOAuthToken.existingSecret }}
{{- else -}}
{{ include "claude-code-api-helm.authSecretName" . }}
{{- end -}}
{{- end }}
