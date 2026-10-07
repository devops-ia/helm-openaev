# Examples

## Global

### Manage secrets

Use `secrets` to create secrets to reference with `envFromSecrets`. By default the secret is created in the same namespace of the release.

> [!IMPORTANT]
> Secrets are encoded with base64.

Name template `{{ include "openaev.fullname" . }}-credentials`. For example if release name is `openaev-ci` the secret name will be `openaev-ci-credentials`.

```yaml
kind: Secret
type: Opaque
metadata:
  name: openaev-ci-credentials
  labels:
    ...
data:
  my_secret: dGVzdA==
```

Can reference the secret using `envFromSecrets` in any (is the same `Secret` for each component):

* server
* caldera
* collector

> [!NOTE]
> A suggestion to facilitate the management of secrets is to use prefixes. For example, for collector secrets save `CONNECTOR_MISP_MY_SECRET` to reference `MISP` collector.

## Server

## Enable health checks

Enable `testConnection` to check if the service is reachable.

```yaml
testConnection: true
```

Or check each service using `readyChecker` to check if the services which depends to run OpenAEV are ready.

> [!IMPORTANT]
> Only works with servies which are deployed like deps in this chart.

```yaml
readyChecker:
  enabled: true
  # -- Number of retries before giving up
  retries: 30
  # -- Timeout for each check
  timeout: 5
  # -- List services
  services:
  - name: rustfs
    address: openaev-ci-rustfs-svc
    port: 9000
  - name: postgresql
    port: 5432
  - name: rabbitmq
    port: 5672
```

In deep this config are deployed as a initial container which check the services (review [deployment.yaml](../templates/server/deployment.yaml)):

```yaml
      initContainers:
      {{- range $service := .Values.readyChecker.services }}
      - name: ready-checker-{{ $service.name }}
        image: busybox
        command:
          - 'sh'
          - '-c'
          - 'RETRY=0; until [ $RETRY -eq {{ $.Values.readyChecker.retries }} ]; do nc -zv {{ $.Values.fullnameOverride | default $.Release.Name }}-{{ $service.name }} {{ $service.port }} && break; echo "[$RETRY/{{ $.Values.readyChecker.retries }}] waiting service {{ $.Values.fullnameOverride | default $.Release.Name }}-{{ $service.name }}:{{ $service.port }} is ready"; sleep {{ $.Values.readyChecker.timeout }}; RETRY=$(($RETRY + 1)); done'
      {{- end }}
```

Output:

```yaml
...
      initContainers:
      - name: ready-checker-rustfs
        image: busybox
        command:
          - 'sh'
          - '-c'
          - 'RETRY=0; until [ $RETRY -eq 30 ]; do nc -zv openaev-ci-rustfs-svc 9000 && break; echo "[$RETRY/30] waiting service openaev-ci-rustfs-svc:9000 is ready"; sleep 5; RETRY=$(($RETRY + 1)); done'
      - name: ready-checker-postgresql
        image: busybox
        command:
          - 'sh'
          - '-c'
          - 'RETRY=0; until [ $RETRY -eq 30 ]; do nc -zv openaev-ci-postgresql 5432 && break; echo "[$RETRY/30] waiting service openaev-ci-postgresql:5432 is ready"; sleep 5; RETRY=$(($RETRY + 1)); done'
      - name: ready-checker-rabbitmq
        image: busybox
        command:
          - 'sh'
          - '-c'
          - 'RETRY=0; until [ $RETRY -eq 30 ]; do nc -zv openaev-ci-rabbitmq 5672 && break; echo "[$RETRY/30] waiting service openaev-ci-rabbitmq:5672 is ready"; sleep 5; RETRY=$(($RETRY + 1)); done'
```

## Collector

### Sample complete

```yaml
collectors:
# https://github.com/OpenAEV-Platform/collectors/tree/main/microsoft-entra
- name: microsoft-entra
  enabled: true
  replicas: 1
  image:
    repository: openaev/collector-microsoft-entra
  env:
    OPENAEV_URL: "XXXX"
    OPENAEV_TOKEN: "XXXX"
    COLLECTOR_ID: ChangeMe
    COLLECTOR_NAME: "Microsoft Entra"
    COLLECTOR_LOG_LEVEL: error
    MICROSOFT_ENTRA_TENANT_ID: "XXXX"
    MICROSOFT_ENTRA_CLIENT_ID: "XXXX"
    INCLUDE_EXTERNAL: "false"
  envFromSecrets:
    MICROSOFT_ENTRA_CLIENT_SECRET:
      name:  my-secret-credentials
      key: MICROSOFT_ENTRA_CLIENT_SECRET
  resources:
    requests:
      memory: 128Mi
      cpu: 100m
    limits:
      memory: 128Mi
```

You can config which node to run the collector using nodeSelector and tolerations.

```yaml
collector:
- name: microsoft-entra
  ...
  nodeSelector:
    project: "openaev"
  tolerations:
    - key: "project"
      operator: "Equal"
      value: "openaev"
      effect: "NoSchedule"
```

Or you can use affinity to run the collector in different node if you increase replicas.

```yaml
- name: microsoft-entra
  ...
  affinity:
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        - labelSelector:
            matchExpressions:
              - key: openaev.collector
                operator: In
                values:
                  - microsoft-entra
          topologyKey: kubernetes.io/hostname
```

## Injector

## Sample complete

```yaml
injectors:
# https://github.com/OpenAEV-Platform/injectors/tree/main/http-query
- name: http-query
  enabled: true
  replicas: 1
  image:
    repository: openaev/injector-http-query
  env:
    OPENAEV_URL: "XXXX"
    OPENAEV_TOKEN: "XXXX"
    INJECTOR_ID: ChangeMe
    INJECTOR_NAME: "HTTP query"
    INJECTOR_LOG_LEVEL: error
  envFromSecrets:
    MICROSOFT_ENTRA_CLIENT_SECRET:
      name:  my-secret-credentials
      key: MICROSOFT_ENTRA_CLIENT_SECRET
  resources:
    requests:
      memory: 128Mi
      cpu: 100m
    limits:
      memory: 128Mi
```

You can config which node to run the injector using nodeSelector and tolerations.

```yaml
injector:
- name: http-query
  ...
  nodeSelector:
    project: "openaev"
  tolerations:
    - key: "project"
      operator: "Equal"
      value: "openaev"
      effect: "NoSchedule"
```

Or you can use affinity to run the injector in different node if you increase replicas.

```yaml
- name: http-query
  ...
  affinity:
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        - labelSelector:
            matchExpressions:
              - key: openaev.injector
                operator: In
                values:
                  - http-query
          topologyKey: kubernetes.io/hostname
```

## Connector and Injector

### Configure image

You can configure default `image` to run the collector or use default `image`.

If you don't set `image` block, by default use `openaev/<name-collector>:<Chart.AppVersion>`.

```yaml
collectors:
- name: http-query
  enabled: true
  replicas: 1
  ...
```

This config use default image: `openaev/http-query:1.1.0`

You can configure `repository` and `tag` to use a custom image.

```yaml
collectors:
- name: http-query
  enabled: true
  replicas: 1
  image:
    repository: my-private-repo/collector-http-query
    tag: "1.1.0"
  ...
```

Now, this config set an image: `my-private-repo/collector-http-query:1.1.0`

### Configure serviceAccount

You can configure default `serviceAccount` to run the collector or use a custom `serviceAccount`. Following code, create a `serviceAccount` named `test` to run the collector.

```yaml
...
collectors:
- name: http-query
  enabled: true
  replicas: 1
  serviceAccount:
    create: true
    name: test
    automountServiceAccountToken: true # false by default
```

Result:

```yaml
# Source: openaev/templates/collector/serviceaccount.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: test
  labels:
    openaev.collector: http-query
    ...
automountServiceAccountToken: true
--
# Source: openaev/templates/collector/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sample-http-query-openaev
  ...
spec:
  ...
  template:
    ...
    spec:
      serviceAccountName: test
```

If you want use default `name` (`<name-collector>-collector-<release-name>`) you can use `create: true` only.

```yaml
...
collectors:
- name: http-query
  enabled: true
  replicas: 1
  serviceAccount:
    create: true
```

Result:

```yaml
# Source: openaev/templates/collector/serviceaccount.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: sample-http-query-openaev
  labels:
    openaev.collector: splunk
    ...
automountServiceAccountToken: true
--
# Source: openaev/templates/collector/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sample-http-query-openaev
  ...
spec:
  ...
  template:
    ...
    spec:
      serviceAccountName: sample-http-query-openaev
```
