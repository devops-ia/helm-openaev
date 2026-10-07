# Basic installation

See [Customizing the chart before installing](https://helm.sh/docs/intro/using_helm/#customizing-the-chart-before-installing). To see all configurable options with comments:

```console
helm show values openaev/openaev
```

You may also helm show values on this chart's dependencies for additional options.

## Components

Basic installation will deploy the following components:

* RustFS
* OpenAEV caldera
* OpenAEV server
* OpenSearch
* PostgreSQL
* RabbitMQ

### OpenAEV server

Basic config server block to configure:

```yaml
env:
  OPENAEV_ADMIN_EMAIL: admin@openaev.io
  OPENAEV_ADMIN_PASSWORD: test
  OPENAEV_ADMIN_TOKEN: b1976749-8a53-4f49-bf04-cafa2a3458c1
  OPENAEV_COOKIE-SECURE: "true"
  INJECTOR_CALDERA_URL: http://openaev-ci-caldera:8888
  INJECTOR_CALDERA_PUBLIC_URL: http://openaev-ci-caldera:8888
  INJECTOR_CALDERA_API_KEY: 238cab90-5a9e-4c6f-8c7c-4ae07a50513f
  ...
```

Expose service:

```yaml
ingress:
  enabled: true
  hosts:
    - host: demo.mydomain.com
      paths:
        - path: /
          pathType: Prefix
```

### OpenAEV caldera

Basic config caldera service block to configure:

```yaml
env:
  CALDERA_URL: "http://localhost:8080"

  config:
    users:
      red:
        red: ChangeMe
    api_key_red: ChangeMe
    api_key: 238cab90-5a9e-4c6f-8c7c-4ae07a50513f
    crypt_salt: ChangeMe
    encryption_key: ChangeMe
    app.contact.http: http://openaev-ci-caldera:8888
    app.contact.tcp: 0.0.0.0:7010
    app.contact.udp: 0.0.0.0:7011
    app.contact.websocket: 0.0.0.0:7012
    app.contact.dns.domain: localhost
    app.contact.dns.socket: 0.0.0.0:53
    app.contact.tunnel.ssh.socket: 0.0.0.0:8022
    app.contact.tunnel.ssh.user_name: sandcat
    app.contact.tunnel.ssh.user_password: ChangeMe
    objects.planners.default: atomic
    ...
```

### RustFS

Server block to configure RustFS (note the `-svc` suffix RustFS always appends to its Service name, regardless of `fullnameOverride`):

```yaml
env:
...
  MINIO_ENDPOINT: <release-name>-rustfs-svc:9000
```

Basic config:

```yaml
rustfs:
  enabled: true
  mode:
    standalone:
      enabled: true
    distributed:
      enabled: false
  secret:
    rustfs:
      access_key: ChangeMe
      secret_key: ChangeMe
```

Configure `envFromSecrets` for server block, pointing at RustFS's auto-generated secret (`<release-name>-rustfs-secret`, keys `RUSTFS_ACCESS_KEY`/`RUSTFS_SECRET_KEY`):

```yaml
envFromSecrets:
  MINIO_ACCESS-KEY:
    name: <release-name>-rustfs-secret
    key: RUSTFS_ACCESS_KEY
  MINIO_ACCESS-SECRET:
    name: <release-name>-rustfs-secret
    key: RUSTFS_SECRET_KEY
```

Unlike MinIO, RustFS standalone mode always provisions PVCs (no emptyDir option) via `rustfs.storageclass`. This chart defaults `rustfs.storageclass.name: ""` so your cluster's default StorageClass is used.

More info. [chart values](https://github.com/rustfs/rustfs/tree/main/helm/rustfs)

### PostgreSQL

Server block to configure PostgreSQL:

```yaml
env:
  SPRING_DATASOURCE_URL: jdbc:postgresql://<release-name>-postgresql:5432/openaev
  SPRING_DATASOURCE_USERNAME: user
  SPRING_DATASOURCE_PASSWORD: ChangeMe
  ...
```

Basic config:

```yaml
postgresql:
  enabled: true
  replicaCount: 1

  auth:
    username: user
    password: ChangeMe

  persistence:
    enabled: false
```

More info. [chart values](https://github.com/bitnami/charts/blob/main/bitnami/postgresql/values.yaml)

### RabbitMQ

Server block to configure RabbitMQ:

```yaml
env:
...
  OPENAEV_RABBITMQ_HOSTNAME: <release-name>-rabbitmq
  OPENAEV_RABBITMQ_MANAGEMENT-PORT: 15672
  OPENAEV_RABBITMQ_PORT: 5672
  OPENAEV_RABBITMQ_USER: user
  OPENAEV_RABBITMQ_PASS: ChangeMe
```

Basic config:

```yaml
rabbitmq:
  enabled: true
  replicaCount: 1
  clustering:
    enabled: false

  auth:
    username: user
    password: ChangeMe
    erlangCookie: ChangeMe

  persistence:
    enabled: false
```

Move `rabbitmq.auth.password` and `rabbitmq.auth.erlangCookie` to `secrets` block for `auth`:

```yaml
secrets:
  rabbitmq-password: MySecretPassword
  rabbitmq-erlang-cookie: MySecretErlangCookie
```

Configure `envFromSecrets` for server block:

```yaml
envFromSecrets:
  RABBITMQ__PASSWORD:
    name: <release-name>-credentials
    key: rabbitmq-password
  RABBITMQ__ERLANGCOOKIE:
    name: <release-name>-credentials
    key: rabbitmq-erlang-cookie
```

Configure RabbitMQ `rabbitmq.auth` with existing secret:

```yaml
rabbitmq.auth.existingPasswordSecret: <release-name>-credentials
rabbitmq.auth.existingErlangSecret: <release-name>-credentials
```

More info. [chart values](https://github.com/bitnami/charts/blob/main/bitnami/rabbitmq/values.yaml)
