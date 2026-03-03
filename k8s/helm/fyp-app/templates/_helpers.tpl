{{/*
Expand the name of the chart.
*/}}
{{- define "fyp-app.name" -}}
{{- .Chart.Name }}
{{- end }}

{{/*
Full name
*/}}
{{- define "fyp-app.fullname" -}}
{{- printf "%s" .Chart.Name }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "fyp-app.labels" -}}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
{{ include "fyp-app.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "fyp-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "fyp-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
