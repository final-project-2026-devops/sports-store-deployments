{{/*
Chart name, used as the app.kubernetes.io/name label.
*/}}
{{- define "sports-store.name" -}}
{{- .Chart.Name -}}
{{- end -}}

{{/*
Common labels applied to every resource this chart creates.
*/}}
{{- define "sports-store.labels" -}}
app.kubernetes.io/name: {{ include "sports-store.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Per-service selector labels — must be identical on the Deployment's
spec.selector.matchLabels and its pod template's labels, and on the
matching Service's spec.selector.
Call with (dict "root" $ "service" $name) since `range` overwrites `.`
with the map value, so the helper needs root and service passed in explicitly.
*/}}
{{- define "sports-store.selectorLabels" -}}
app.kubernetes.io/name: {{ .root.Chart.Name }}
app.kubernetes.io/component: {{ .service }}
{{- end -}}
