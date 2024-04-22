{{/*
Expand the name of the chart.
*/}}
{{- define "websight-cms.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "websight-cms.fullname" -}}
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
{{- define "websight-cms.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "websight-cms.labels" -}}
helm.sh/chart: {{ include "websight-cms.chart" . }}
{{ include "websight-cms.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "websight-cms.selectorLabels" -}}
app.kubernetes.io/name: {{ include "websight-cms.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create a default fully qualified component name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
Usage:
{{ include "websight-cms.component.fullname" (dict "componentName" "component-name" "context" $) }}
*/}}
{{- define "websight-cms.component.fullname" -}}
{{- if .context.Values.fullnameOverride }}
{{- printf "%s-%s" .context.Values.fullnameOverride .componentName | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .context.Chart.Name .context.Values.nameOverride }}
{{- if contains $name .context.Release.Name }}
{{- printf "%s-%s" .context.Release.Name .componentName | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s-%s" .context.Release.Name $name .componentName | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create the name of the component-type shared service account to use.

Usage:
{{ include "websight-cms.component.serviceAccountName" (dict "componentName" "component-name" "serviceAccount" saObject "context" $) }}
*/}}
{{- define "websight-cms.component.serviceAccountName" -}}
{{- if .serviceAccount.create -}}
    {{ .serviceAccount.name | default (include "websight-cms.component.fullname" (dict "componentName" .componentName "context" .context)) }}
{{- else -}}
    {{ .serviceAccount.name | default "default" }}
{{- end -}}
{{- end }}

{{/*
Metadata labels for CMS component
Usage:
{{ include "websight-cms.component.labels" (dict "componentName" "component-name" "context" $) }}
*/}}
{{- define "websight-cms.component.labels" -}}
helm.sh/chart: {{ include "websight-cms.chart" .context }}
{{ include "websight-cms.component.selectorLabels" (dict "componentName" .componentName "context" .context) }}
{{- if .context.Chart.AppVersion }}
app.kubernetes.io/version: {{ .context.Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .context.Release.Service }}
{{- end }}

{{/*
Selector labels for CMS component
Usage:
{{ include "websight-cms.component.selectorLabels" (dict "componentName" "component-name" "context" $) }}
*/}}
{{- define "websight-cms.component.selectorLabels" -}}
{{ include "websight-cms.selectorLabels" .context }}
app.kubernetes.io/component: {{ .componentName }}
{{- end }}