{{/*
Expand the name of the chart.
*/}}
{{- define "pipeline.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "pipeline.fullname" -}}
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

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "pipeline.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "pipeline.labels" -}}
helm.sh/chart: {{ include "pipeline.chart" . }}
{{ include "pipeline.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "pipeline.selectorLabels" -}}
app.kubernetes.io/name: {{ include "pipeline.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "pipeline.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "pipeline.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the pipeline controller role to use
*/}}
{{- define "pipeline.controllerRoleName" -}}
{{- if .Values.rbac.create }}
{{- default (include "pipeline.fullname" .) .Values.rbac.controller.name }}
{{- else }}
{{- default "default" .Values.rbac.controller.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the pipeline leader role to use
*/}}
{{- define "pipeline.leaderRoleName" -}}
{{- if .Values.rbac.create }}
{{- default (printf "%s-leader" (include "pipeline.fullname" .)) .Values.rbac.leader.name }}
{{- else }}
{{- default "default" .Values.rbac.leader.name }}
{{- end }}
{{- end }}
