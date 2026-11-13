{{/*
Collectors and injectors share the same Deployment and ServiceAccount.
Call with: dict "root" $ "kind" "collector" "items" .Values.collectors "global" .Values.collectorsGlobal
*/}}
{{- define "openaev.extension.deployment" -}}
{{- $root := .root }}
{{- $kind := .kind }}
{{- $global := .global }}
{{- $appAdminToken := "" -}}
{{- range $root.Values.secrets -}}
  {{- if and (hasKey .data "OPENAEV_ADMIN_TOKEN") (not $appAdminToken) -}}
    {{- $appAdminToken = index .data "OPENAEV_ADMIN_TOKEN" -}}
  {{- end -}}
{{- end -}}
{{- if and (hasKey $root.Values.env "OPENAEV_ADMIN_TOKEN") (not $appAdminToken) -}}
  {{- $appAdminToken = $root.Values.env.OPENAEV_ADMIN_TOKEN -}}
{{- end -}}

{{- range .items }}
{{- $name := .name }}

{{- if .enabled }}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "openaev.fullname" $root }}-{{ $name }}-{{ $kind }}
  {{- with .deploymentAnnotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  labels:
    openaev.{{ $kind }}: {{ $name }}
    {{- include "openaev.labels" $root | nindent 4 }}
spec:
  {{- if not .autoscaling }}
  replicas: {{ .replicas }}
  {{- end }}
  {{- with .strategy }}
  strategy:
    {{- toYaml . | nindent 4 }}
  {{- end }}
  selector:
    matchLabels:
      openaev.{{ $kind }}: {{ $name }}
      {{- include "openaev.selectorLabels" $root | nindent 6 }}
  template:
    metadata:
      {{- with .podAnnotations }}
      annotations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      labels:
        openaev.{{ $kind }}: {{ $name }}
        {{- include "openaev.selectorLabels" $root | nindent 8 }}
        {{- with .podLabels }}
        {{- toYaml . | nindent 8 }}
        {{- end }}
    spec:
      {{- if .imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml .imagePullSecrets | nindent 8 }}
      {{- else if $root.Values.global.imagePullSecrets }}
      imagePullSecrets:
        {{- toYaml $root.Values.global.imagePullSecrets | nindent 8 }}
      {{- end }}
      {{- if .serviceAccount }}
      serviceAccountName: {{ if and .serviceAccount (hasKey .serviceAccount "name") }}{{ .serviceAccount.name }}{{ else }}{{ $name }}-{{ $kind }}-{{ include "openaev.fullname" $root }}{{ end }}
      {{- end }}
      securityContext:
        {{- toYaml .podSecurityContext | nindent 8 }}
      {{- if and .readyChecker (hasKey .readyChecker "enabled") }}
      {{- if .readyChecker.enabled }}
      initContainers:
        - name: ready-checker-server
          {{- if $root.Values.global.imageRegistry }}
          image: "{{ $root.Values.global.imageRegistry }}/{{ .readyChecker.image | default "busybox" }}:{{ .readyChecker.tag | default "latest" }}"
          {{- else }}
          image: {{ .readyChecker.repository | default "busybox" }}:{{ .readyChecker.tag | default "latest" }}
          imagePullPolicy: {{ .readyChecker.pullPolicy | default "IfNotPresent" }}
          {{- end }}
          command:
            - 'sh'
            - '-c'
            - >
              RETRY=0;
              until [ $RETRY -eq {{ .readyChecker.retries }} ];
              do
                if nc -zv {{ $root.Values.fullnameOverride | default (include "openaev.fullname" $root) }}-server {{ $root.Values.service.port }}; then
                  echo "Service {{ $root.Values.fullnameOverride | default (include "openaev.fullname" $root) }}-server:{{ $root.Values.service.port }} is ready";
                  exit 0;
                fi;
                echo "[$RETRY/{{ .readyChecker.retries }}] waiting service {{ $root.Values.fullnameOverride | default (include "openaev.fullname" $root) }}-server:{{ $root.Values.service.port }} is ready";
                sleep {{ .readyChecker.timeout }};
                RETRY=$(($RETRY + 1));
                if [ $RETRY -eq {{ .readyChecker.retries }} ]; then
                  echo "Service {{ $root.Values.fullnameOverride | default (include "openaev.fullname" $root) }}-server:{{ $root.Values.service.port }} did not become ready after {{ .readyChecker.retries }} retries";
                  exit 1;
                fi;
              done
        {{- $rc := .readyChecker }}
        {{- range $service := .readyChecker.services }}
        - name: ready-checker-{{ $service.name }}
          {{- if $root.Values.global.imageRegistry }}
          image: "{{ $root.Values.global.imageRegistry }}/{{ $root.Values.readyChecker.repository }}:{{ $root.Values.readyChecker.tag }}"
          {{- else }}
          image: {{ $root.Values.readyChecker.repository }}:{{ $root.Values.readyChecker.tag }}
          {{- end }}
          imagePullPolicy: {{ $root.Values.readyChecker.pullPolicy }}
          command:
            - 'sh'
            - '-c'
            - |
              RETRY=0;
              until [ $RETRY -eq {{ $rc.retries }} ];
              do
                ADDRESS="{{ if $service.address }}{{ $service.address }}{{ else }}{{ $root.Values.fullnameOverride | default $root.Release.Name }}-{{ $service.name }}{{ end }}";
                if nc -zv $ADDRESS {{ $service.port }}; then
                  echo "Service {{ $service.name }} with address $ADDRESS:{{ $service.port }} is ready";
                  exit 0;
                fi;
                echo "[$RETRY/{{ $rc.retries }}] waiting for service {{ $service.name }} with address $ADDRESS:{{ $service.port }} to become ready";
                sleep {{ $rc.timeout }};
                RETRY=$(($RETRY + 1));
                if [ $RETRY -eq {{ $rc.retries }} ]; then
                  echo "Service {{ $service.name }} with address $ADDRESS:{{ $service.port }} is not ready";
                  exit 1;
                fi;
              done
        {{- end }}
      {{- end }}
      {{- end }}
      containers:
        - name: {{ $name }}-{{ $kind }}
          securityContext:
            {{- toYaml .securityContext | nindent 12 }}
          image: "{{- if and .image (hasKey .image "repository") }}{{ .image.repository }}{{- else if $root.Values.global.imageRegistry }}{{ printf "%s/openaev/%s" $root.Values.global.imageRegistry .name }}{{- else }}{{ printf "openaev/%s" .name }}{{- end }}:{{ if and .image (hasKey .image "tag") }}{{ .image.tag | default $root.Chart.AppVersion }}{{ else }}{{ $root.Chart.AppVersion }}{{ end }}"
          imagePullPolicy: {{ if and .image (hasKey .image "pullPolicy") }}{{ .image.pullPolicy }}{{ else }}IfNotPresent{{ end }}
          lifecycle:
            {{- with .lifecycle }}
            {{- toYaml . | nindent 12 }}
            {{- end }}
          envFrom:
            {{- if .envFromFiles }}
            {{- tpl (toYaml .envFromFiles) . | nindent 12 }}
            {{- end }}
            {{- if $global.envFromFiles }}
            {{- tpl (toYaml $global.envFromFiles) . | nindent 12 }}
            {{- end }}
          env:
            # Variables from secrets have precedence
            # {{ $kind | title }} specific env from secrets
            {{- $envList := dict -}}
            {{- if .envFromSecrets }}
            {{- range $key, $value := .envFromSecrets }}
            - name: {{ $key | upper }}
              valueFrom:
                secretKeyRef:
                  name: {{ $value.name }}
                  key: {{ $value.key | default $key }}
            {{- $_ := set $envList $key true }}
            {{- end }}
            {{- end }}
            # Variables from configmap have precedence
            {{- if .envFromConfigMap }}
            {{- range $key, $value := .envFromConfigMap }}
            {{- if not (hasKey $envList $key) }}
            - name: {{ $key | upper }}
              valueFrom:
                configMapKeyRef:
                  name: {{ $value.name }}
                  key: {{ $value.key | default $key }}
            {{- $_ := set $envList $key true }}
            {{- end }}
            {{- end }}
            {{- end }}
            # Add variables in plain text if they were not already added from secrets
            {{- if .env }}
            {{- range $key, $value := .env }}
            {{- if not (hasKey $envList $key) }}
            - name: {{ $key | upper }}
              value: {{ $value | quote }}
            {{- $_ := set $envList $key true }}
            {{- end }}
            {{- end }}
            {{- end }}
            # {{ $kind | title }}s global env from secrets
            {{- if $global.envFromSecrets }}
            {{- range $key, $value := $global.envFromSecrets }}
            {{- if not (hasKey $envList $key) }}
            - name: {{ $key | upper }}
              valueFrom:
                secretKeyRef:
                  name: {{ $value.name }}
                  key: {{ $value.key | default $key }}
            {{- $_ := set $envList $key true }}
            {{- end }}
            {{- end }}
            {{- end }}
            # {{ $kind | title }}s global env from configmap
            {{- if $global.envFromConfigMap }}
            {{- range $key, $value := $global.envFromConfigMap }}
            {{- if not (hasKey $envList $key) }}
            - name: {{ $key | upper }}
              valueFrom:
                secretKeyRef:
                  name: {{ $value.name }}
                  key: {{ $value.key | default $key }}
            {{- $_ := set $envList $key true }}
            {{- end }}
            {{- end }}
            {{- end }}
            # {{ $kind | title }}s global env
            {{- if $global.env }}
            {{- range $key, $value := $global.env }}
            {{- if not (hasKey $envList $key) }}
            - name: {{ $key | upper }}
              value: {{ $value | quote }}
            {{- $_ := set $envList $key true }}
            {{- end }}
            {{- end }}
            {{- end }}
            {{- if not (hasKey $envList "OPENAEV_URL") }}
            {{- if eq $root.Values.env.APP__BASE_PATH "/" }}
            - name: OPENAEV_URL
              value: "http://{{ include "openaev.fullname" $root }}-server:{{ $root.Values.service.port }}"
            {{- else }}
            - name: OPENAEV_URL
              value: "http://{{ include "openaev.fullname" $root }}-server:{{ $root.Values.service.port }}{{ $root.Values.env.APP__BASE_PATH }}"
            {{- end }}
            {{- end }}
            {{- if and (not (hasKey $envList "OPENAEV_TOKEN")) $appAdminToken }}
            - name: OPENAEV_TOKEN
              value: {{ $appAdminToken }}
            {{- end }}
          volumeMounts:
            {{- with .volumeMounts }}
              {{- toYaml . | nindent 12 }}
            {{- end }}
            {{- with $global.volumeMounts }}
              {{- toYaml . | nindent 12 }}
            {{- end }}
          resources:
            {{- toYaml .resources | nindent 12 }}
      terminationGracePeriodSeconds: {{ .terminationGracePeriodSeconds | default 30 }}
      volumes:
      {{- with .volumes }}
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with $global.volumes }}
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .nodeSelector }}
      nodeSelector:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .tolerations }}
      tolerations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .affinity }}
      affinity:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .topologySpreadConstraints }}
      topologySpreadConstraints:
        {{- range $constraint := . }}
        - labelSelector:
            matchLabels:
              openaev.{{ $kind }}: {{ $name }}
              {{- include "openaev.selectorLabels" $root | nindent 14 }}
          {{- toYaml $constraint | nindent 10 }}
        {{- end }}
      {{- end }}
      {{- with .dnsConfig }}
      dnsConfig:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .dnsPolicy }}
      dnsPolicy: {{ . }}
      {{- end }}
{{- end }}
{{- end }}
{{- end }}

{{- define "openaev.extension.serviceaccount" -}}
{{- $root := .root }}
{{- $kind := .kind }}
{{- $global := .global }}
{{- range .items }}
{{- $name := .name }}

{{ if and .serviceAccount (hasKey .serviceAccount "create") }}
{{- if .serviceAccount.create -}}
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ if and .serviceAccount (hasKey .serviceAccount "name") }}{{ .serviceAccount.name }}{{ else }}{{ $name }}-{{ $kind }}-{{ include "openaev.fullname" $root }}{{ end }}
  labels:
    openaev.{{ $kind }}: {{ $name }}
    {{- include "openaev.labels" $root | nindent 4 }}
  {{- with .serviceAccount.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
automountServiceAccountToken: {{ .serviceAccount.automountServiceAccountToken | default "false" }}
{{- end }}
{{- end }}

{{- end }}
{{- end }}
