{{/*
Expand the name of the chart.
*/}}
{{- define "foo-bar-app.name" -}}
{{- default .Chart.Name .Values.appName | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "foo-bar-app.fullname" -}}
{{- printf "%s-%s" .Release.Name (include "foo-bar-app.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Common labels
*/}}
{{- define "foo-bar-app.labels" -}}
app.kubernetes.io/name: {{ include "foo-bar-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "foo-bar-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "foo-bar-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}