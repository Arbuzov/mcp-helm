{{/*
Expand the name of the chart
*/}}
{{- define "search-helm-chart.name" -}}
{{- .Chart.Name | quote -}}
{{- end -}}

{{/*
Expand the full name of the chart
*/}}
{{- define "search-helm-chart.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | quote -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "search-helm-chart.labels" -}}
app: {{ include "search-helm-chart.name" . }}
release: {{ .Release.Name }}
{{- end -}}

{{/*
Get the image name
*/}}
{{- define "search-helm-chart.image" -}}
{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}
{{- end -}}

{{/*
Get the service name
*/}}
{{- define "search-helm-chart.serviceName" -}}
{{ include "search-helm-chart.fullname" . }}-service
{{- end -}}