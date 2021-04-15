{{/*
Expand the name of the chart.
*/}}
{{- define "es-cluster.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "es-cluster.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "es-cluster.labels" -}}
helm.sh/chart: {{ include "es-cluster.chart" . }}
{{ include "es-cluster.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "kibanaLabels" -}}
helm.sh/chart: {{ include "es-cluster.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{ include "kibanaSelectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}

{{- define "kibanaSelectorLabels" -}}
app: {{ .Values.kibana.appLabel }}
instance: {{ .Release.Name }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "es-cluster.selectorLabels" -}}
app: {{ .Values.elastic.statefulSetName }}
instance: {{ .Release.Name }}
{{- end }}

{{/*
Create master node list
*/}}

{{- define "masterNodes" -}}
{{- $prefix := .elastic.statefulSetName }}
{{- $list := dict "servers" (list) -}}
{{- range int .elastic.replicaCount | until -}}
{{- $noop := printf "%s-%d" $prefix . | append $list.servers | set $list "servers" -}}
{{- end -}}
{{- join "," $list.servers -}}
{{- end -}}


{{- define "nodesFQDN" -}}
{{- $prefix := .Values.elastic.statefulSetName }}
{{- $baseDomain := .Release.Namespace }}
{{- $service := .Values.elastic.service.transport.name }}
{{- $list := dict "servers" (list) -}}
{{- range int .Values.elastic.replicaCount | until -}}
{{- $noop := printf "%s-%d.%s.%s.svc.cluster.local" $prefix . $service $baseDomain | append $list.servers | set $list "servers" -}}
{{- end -}}
{{- join "," $list.servers -}}
{{- end -}}
