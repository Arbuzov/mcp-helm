{{/* Expand the name of the chart. */}}
{{- define "mcp-library.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Render a structure as YAML with template interpolation */}}
{{- define "mcp-library.tplvalues.render" -}}
{{- $root := index . 0 -}}
{{- $vals := index . 1 -}}
{{- tpl (toYaml $vals) $root }}
{{- end }}

{{/* Extra volumes for pod spec */}}
{{- define "mcp-library.extraVolumes" -}}
{{- if .Values.extraVolumes }}
{{- include "mcp-library.tplvalues.render" (list . .Values.extraVolumes) }}
{{- end }}
{{- end }}

{{/* Extra volume mounts for containers */}}
{{- define "mcp-library.extraVolumeMounts" -}}
{{- if .Values.extraVolumeMounts }}
{{- include "mcp-library.tplvalues.render" (list . .Values.extraVolumeMounts) }}
{{- end }}
{{- end }}

{{/* Extra environment variables for containers */}}
{{- define "mcp-library.extraEnvs" -}}
{{- if .Values.extraEnvs }}
{{- include "mcp-library.tplvalues.render" (list . .Values.extraEnvs) }}
{{- end }}
{{- end }}

{{/* Create a default fully qualified app name. */}}
{{- define "mcp-library.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/* Create chart name and version as used by the chart label. */}}
{{- define "mcp-library.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Common labels */}}
{{- define "mcp-library.labels" -}}
helm.sh/chart: {{ include "mcp-library.chart" . }}
{{ include "mcp-library.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/* Selector labels */}}
{{- define "mcp-library.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mcp-library.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/* Create the name of the service account to use */}}
{{- define "mcp-library.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mcp-library.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* Compute ingress path with regex suffix when path prefix is set */}}
{{- define "mcp-library.ingressPath" -}}
{{- if and .Values.ingress.path (ne .Values.ingress.path "/") -}}
{{ printf "%s(/|$)(.*)" .Values.ingress.path }}
{{- else -}}
/
{{- end -}}
{{- end }}

{{/* Ensure regex annotation for custom ingress paths */}}
{{- define "mcp-library.ingressUseRegex" -}}
{{- if and (ne .Values.ingress.path "/") (not (hasKey .Values.ingress.annotations "nginx.ingress.kubernetes.io/use-regex")) -}}
{{- $_ := set .Values.ingress.annotations "nginx.ingress.kubernetes.io/use-regex" "true" -}}
{{- end -}}
{{- end }}
