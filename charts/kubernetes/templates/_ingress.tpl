{{- define "mcp-kubernetes-helm.ensureIngressRewrite" -}}
{{- if and .Values.ingress.path (ne .Values.ingress.path "/") -}}
  {{- if not .Values.ingress.annotations }}
    {{- $_ := set .Values.ingress "annotations" (dict) }}
  {{- end }}
  {{- if not (hasKey .Values.ingress.annotations "nginx.ingress.kubernetes.io/rewrite-target") }}
    {{- $_ := set .Values.ingress.annotations "nginx.ingress.kubernetes.io/rewrite-target" "/$2" }}
  {{- end }}
{{- end }}
{{- end }}
