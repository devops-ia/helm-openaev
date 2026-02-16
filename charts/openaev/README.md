# openaev

A Helm chart to deploy Open Breach and Attack Simulation platform

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| ialejandro | <hello@ialejandro.rocks> | <https://ialejandro.rocks> |

## Prerequisites

* Helm 3+

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.min.io/ | minio | 5.4.0 |
| https://opensearch-project.github.io/helm-charts/ | opensearch | 3.5.0 |
| oci://registry-1.docker.io/bitnamicharts | postgresql | 16.7.27 |
| oci://registry-1.docker.io/bitnamicharts | rabbitmq | 16.0.14 |

## Add repository

```console
helm repo add openaev https://devops-ia.github.io/helm-openaev
helm repo update
```

## Install Helm chart (repository mode)

```console
helm install [RELEASE_NAME] openaev/openaev
```

This install all the Kubernetes components associated with the chart and creates the release.

_See [helm install](https://helm.sh/docs/helm/helm_install/) for command documentation._

## Install Helm chart (OCI mode)

Charts are also available in OCI format. The list of available charts can be found [here](https://github.com/devops-ia/helm-openaev/pkgs/container/helm-openaev%2Fopenaev).

```console
helm install [RELEASE_NAME] oci://ghcr.io/devops-ia/helm-openaev/openaev --version=[version]
```

## Uninstall Helm chart

```console
helm uninstall [RELEASE_NAME]
```

This removes all the Kubernetes components associated with the chart and deletes the release.

_See [helm uninstall](https://helm.sh/docs/helm/helm_uninstall/) for command documentation._

## OpenAEV

* [Environment configuration](https://docs.openaev.io/latest/deployment/configuration/#platform)
* [Collectors](https://github.com/OpenAEV-Platform/collectors/tree/main). Review `docker-compose.yaml` with the properly config or check collectors samples on [`collector-examples`](./examples/collector) folder.
* [Injectors](https://github.com/OpenAEV-Platform/injectors/tree/main). Review `docker-compose.yaml` with the properly config or check injectors samples on [`injector-examples`](./examples/injector) folder.

## Basic installation and examples

See [basic installation](docs/configuration.md) and [examples](docs/examples.md).

## Configuration

See [Customizing the chart before installing](https://helm.sh/docs/intro/using_helm/#customizing-the-chart-before-installing). To see all configurable options with comments:

```console
helm show values openaev/openaev
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity for pod assignment </br> Ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity |
| args | list | `[]` | Configure args </br> Ref: https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/ |
| autoscaling | object | `{"enabled":false,"maxReplicas":100,"minReplicas":1,"targetCPUUtilizationPercentage":80}` | Autoscaling with CPU or memory utilization percentage </br> Ref: https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/ |
| caldera | object | `{"affinity":{},"args":[],"autoscaling":{"enabled":false,"maxReplicas":100,"minReplicas":1,"targetCPUUtilizationPercentage":80},"command":[],"config":{},"dnsConfig":{},"dnsPolicy":"ClusterFirst","enabled":true,"env":{},"envFromSecrets":{},"image":{"pullPolicy":"IfNotPresent","repository":"openaev/caldera-server","tag":"5.1.0"},"imagePullSecrets":[],"ingress":{"annotations":{},"className":"","enabled":false,"hosts":[{"host":"chart-example.local","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}],"tls":[]},"initContainers":[],"lifecycle":{},"networkPolicy":{"egress":[],"enabled":false,"ingress":[],"policyTypes":[]},"nodeSelector":{},"podAnnotations":{},"podDisruptionBudget":{"enabled":false,"maxUnavailable":1},"podLabels":{},"podSecurityContext":{},"replicaCount":1,"resources":{},"securityContext":{},"service":{"annotations":{},"appProtocol":"HTTP","extraPorts":[],"labels":{},"loadBalancer":{},"port":8888,"portName":"http","protocol":"TCP","targetPort":8888,"type":"ClusterIP"},"strategy":{},"terminationGracePeriodSeconds":30,"tolerations":[],"topologySpreadConstraints":[],"volumeMounts":[],"volumes":[]}` | OpenAEV caldera-server deployment configuration |
| caldera.affinity | object | `{}` | Affinity for pod assignment </br> Ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity |
| caldera.args | list | `[]` | Configure args </br> Ref: https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/ |
| caldera.autoscaling | object | `{"enabled":false,"maxReplicas":100,"minReplicas":1,"targetCPUUtilizationPercentage":80}` | Autoscaling with CPU or memory utilization percentage </br> Ref: https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/ |
| caldera.command | list | `[]` | Configure command </br> Ref: https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/ |
| caldera.config | object | `{}` | Caldera configuration </br> Ref: https://github.com/OpenAEV-Platform/docker/blob/master/caldera.yml |
| caldera.dnsConfig | object | `{}` | Configure DNS </br> Ref: https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/ |
| caldera.dnsPolicy | string | `"ClusterFirst"` | Configure DNS policy Options: ClusterFirst, Default, ClusterFirstWithHostNet, None </br> Ref: https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/ |
| caldera.enabled | bool | `true` | Enable or disable Caldera server |
| caldera.env | object | `{}` | Environment variables to configure application </br> Ref: https://docs.openaev.io/latest/deployment/configuration/#platform |
| caldera.envFromSecrets | object | `{}` | Secrets from variables |
| caldera.image | object | `{"pullPolicy":"IfNotPresent","repository":"openaev/caldera-server","tag":"5.1.0"}` | Image registry configuration for the base service |
| caldera.image.pullPolicy | string | `"IfNotPresent"` | Pull policy for the image |
| caldera.image.repository | string | `"openaev/caldera-server"` | Repository of the image |
| caldera.image.tag | string | `"5.1.0"` | Overrides the image tag whose default is the chart appVersion |
| caldera.imagePullSecrets | list | `[]` | Specifies the secrets to use for pulling images from private registries Leave empty if no secrets are required E.g. imagePullSecrets:   - name: myRegistryKeySecretName |
| caldera.ingress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[{"host":"chart-example.local","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}],"tls":[]}` | Ingress configuration to expose app </br> Ref: https://kubernetes.io/docs/concepts/services-networking/ingress/ |
| caldera.initContainers | list | `[]` | Configure additional containers </br> Ref: https://kubernetes.io/docs/concepts/workloads/pods/init-containers/ |
| caldera.lifecycle | object | `{}` | Configure lifecycle hooks </br> Ref: https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/ </br> Ref: https://learnk8s.io/graceful-shutdown |
| caldera.networkPolicy | object | `{"egress":[],"enabled":false,"ingress":[],"policyTypes":[]}` | NetworkPolicy configuration </br> Ref: https://kubernetes.io/docs/concepts/services-networking/network-policies/ |
| caldera.networkPolicy.enabled | bool | `false` | Enable or disable NetworkPolicy |
| caldera.networkPolicy.policyTypes | list | `[]` | Policy types |
| caldera.nodeSelector | object | `{}` | Node labels for pod assignment </br> Ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector |
| caldera.podAnnotations | object | `{}` | Configure annotations on Pods |
| caldera.podDisruptionBudget | object | `{"enabled":false,"maxUnavailable":1}` | Pod Disruption Budget </br> Ref: https://kubernetes.io/docs/reference/kubernetes-api/policy-resources/pod-disruption-budget-v1/ |
| caldera.podLabels | object | `{}` | Configure labels on Pods |
| caldera.podSecurityContext | object | `{}` | Defines privilege and access control settings for a Pod </br> Ref: https://kubernetes.io/docs/concepts/security/pod-security-standards/ </br> Ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/ |
| caldera.replicaCount | int | `1` | Number of replicas for the service |
| caldera.resources | object | `{}` | The resources limits and requested </br> Ref: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
| caldera.securityContext | object | `{}` | Defines privilege and access control settings for a Container </br> Ref: https://kubernetes.io/docs/concepts/security/pod-security-standards/ </br> Ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/ |
| caldera.service | object | `{"annotations":{},"appProtocol":"HTTP","extraPorts":[],"labels":{},"loadBalancer":{},"port":8888,"portName":"http","protocol":"TCP","targetPort":8888,"type":"ClusterIP"}` | Kubernetes service to expose Pod </br> Ref: https://kubernetes.io/docs/concepts/services-networking/service/ |
| caldera.service.annotations | object | `{}` | Annotations for the service |
| caldera.service.appProtocol | string | `"HTTP"` | Application protocol (HTTP, HTTPS, etc.) |
| caldera.service.extraPorts | list | `[]` | Pod extra ports |
| caldera.service.labels | object | `{}` | Additional labels for the service |
| caldera.service.loadBalancer | object | `{}` | LoadBalancer specific configuration |
| caldera.service.port | int | `8888` | Kubernetes Service port |
| caldera.service.portName | string | `"http"` | Name for the service port |
| caldera.service.protocol | string | `"TCP"` | Protocol for the service port |
| caldera.service.targetPort | int | `8888` | Pod expose port |
| caldera.service.type | string | `"ClusterIP"` | Kubernetes Service type. Allowed values: NodePort, LoadBalancer, ClusterIP, ExternalName |
| caldera.strategy | object | `{}` | Configure strategy for the deployment |
| caldera.terminationGracePeriodSeconds | int | `30` | Configure Pod termination grace period </br> Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#pod-termination |
| caldera.tolerations | list | `[]` | Tolerations for pod assignment </br> Ref: https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/ |
| caldera.topologySpreadConstraints | list | `[]` | Control how Pods are spread across your cluster </br> Ref: https://kubernetes.io/docs/concepts/scheduling-eviction/topology-spread-constraints/#example-multiple-topologyspreadconstraints |
| caldera.volumeMounts | list | `[]` | Additional volumeMounts on the output Deployment definition |
| caldera.volumes | list | `[]` | Additional volumes on the output Deployment definition |
| collectors | list | `[]` | Collectors </br> Ref: https://github.com/OpenAEV-Platform/collectors |
| collectorsGlobal | object | `{"env":{},"envFromConfigMap":{},"envFromFiles":[],"envFromSecrets":{},"volumeMounts":[],"volumes":[]}` | Collector global configuration |
| collectorsGlobal.env | object | `{}` | Additional environment variables on the output connector definition |
| collectorsGlobal.envFromConfigMap | object | `{}` | Variables from configMap |
| collectorsGlobal.envFromFiles | list | `[]` | Load all variables from files |
| collectorsGlobal.envFromSecrets | object | `{}` | Variables from secrets |
| collectorsGlobal.volumeMounts | list | `[]` | Additional volumeMounts on the output connector Deployment definition |
| collectorsGlobal.volumes | list | `[]` | Additional volumes on the output connector Deployment definition |
| command | list | `[]` | Configure command </br> Ref: https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/ |
| configMaps | list | `[]` | ConfigMap values to create configuration files Generate ConfigMap with following name: <release-name>-<name> </br> Ref: https://kubernetes.io/docs/concepts/configuration/configmap/ |
| dnsConfig | object | `{}` | Configure DNS </br> Ref: https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/ |
| dnsPolicy | string | `"ClusterFirst"` | Configure DNS policy Options: ClusterFirst, Default, ClusterFirstWithHostNet, None </br> Ref: https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/ |
| env | object | `{"INJECTOR_CALDERA_API_KEY":"ChangeMe","INJECTOR_CALDERA_PUBLIC_URL":"http://release-name-caldera:8888","INJECTOR_CALDERA_URL":"http://release-name-caldera:8888","MINIO_ENDPOINT":"release-name-minio:9000","OPENBAS_ADMIN_EMAIL":"admin@openaev.io","OPENBAS_ADMIN_PASSWORD":"ChangeMe","OPENBAS_ADMIN_TOKEN":"ChangeMe","OPENBAS_AUTH-LOCAL-ENABLE":true,"OPENBAS_BASE-URL":"http://localhost:8080","OPENBAS_RABBITMQ_HOSTNAME":"release-name-rabbitmq","OPENBAS_RABBITMQ_MANAGEMENT-PORT":15672,"OPENBAS_RABBITMQ_PASS":"ChangeMe","OPENBAS_RABBITMQ_PORT":5672,"OPENBAS_RABBITMQ_USER":"user","SERVER_ADDRESS":"0.0.0.0","SERVER_PORT":8080,"SPRING_DATASOURCE_PASSWORD":"ChangeMe","SPRING_DATASOURCE_URL":"jdbc:postgresql://release-name-postgresql:5432/openaev","SPRING_DATASOURCE_USERNAME":"user"}` | Environment variables to configure application </br> Ref: https://docs.openaev.io/latest/deployment/configuration/#platform |
| envFromConfigMap | object | `{}` | Variables from configMap |
| envFromFiles | list | `[]` | Load all variables from files </br> Ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#configure-all-key-value-pairs-in-a-configmap-as-container-environment-variables |
| envFromSecrets | object | `{}` | Variables from secrets |
| fullnameOverride | string | `""` | String to fully override openaev.fullname template |
| global | object | `{"imagePullSecrets":[],"imageRegistry":""}` | Global section contains configuration options that are applied to all services |
| global.imagePullSecrets | list | `[]` | Specifies the secrets to use for pulling images from private registries Leave empty if no secrets are required E.g. imagePullSecrets:   - name: myRegistryKeySecretName |
| global.imageRegistry | string | `""` | Specifies the registry to pull images from. Leave empty for the default registry |
| image | object | `{"pullPolicy":"IfNotPresent","repository":"openaev/platform","tag":""}` | Image registry configuration for the base service |
| image.pullPolicy | string | `"IfNotPresent"` | Pull policy for the image |
| image.repository | string | `"openaev/platform"` | Repository of the image |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion |
| imagePullSecrets | list | `[]` | Specifies the secrets to use for pulling images from private registries Leave empty if no secrets are required E.g. imagePullSecrets:   - name: myRegistryKeySecretName |
| ingress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[{"host":"chart-example.local","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}],"tls":[]}` | Ingress configuration to expose app </br> Ref: https://kubernetes.io/docs/concepts/services-networking/ingress/ |
| initContainers | list | `[]` | Configure additional containers </br> Ref: https://kubernetes.io/docs/concepts/workloads/pods/init-containers/ |
| injectors | list | `[]` | Injectors </br> Ref: https://github.com/OpenAEV-Platform/injectors |
| injectorsGlobal | object | `{"env":{},"envFromConfigMap":{},"envFromFiles":[],"envFromSecrets":{},"volumeMounts":[],"volumes":[]}` | Injector global configuration |
| injectorsGlobal.env | object | `{}` | Additional environment variables on the output connector definition |
| injectorsGlobal.envFromConfigMap | object | `{}` | Variables from configMap |
| injectorsGlobal.envFromFiles | list | `[]` | Load all variables from files |
| injectorsGlobal.envFromSecrets | object | `{}` | Variables from secrets |
| injectorsGlobal.volumeMounts | list | `[]` | Additional volumeMounts on the output connector Deployment definition |
| injectorsGlobal.volumes | list | `[]` | Additional volumes on the output connector Deployment definition |
| lifecycle | object | `{}` | Configure lifecycle hooks </br> Ref: https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/ </br> Ref: https://learnk8s.io/graceful-shutdown |
| livenessProbe | object | `{"enabled":true,"failureThreshold":3,"initialDelaySeconds":180,"periodSeconds":10,"successThreshold":1,"timeoutSeconds":5}` | Configure liveness checker </br> Ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-startup-probes |
| livenessProbeCustom | object | `{}` | Custom livenessProbe |
| minio | object | `{"enabled":true,"mode":"standalone","persistence":{"enabled":false},"resources":{"requests":{"memory":"512Mi"}},"rootPassword":"ChangeMe","rootUser":"ChangeMe"}` | MinIO subchart deployment </br> Ref: https://github.com/minio/minio/blob/main/helm/minio/values.yaml |
| minio.enabled | bool | `true` | Enable or disable MinIO subchart |
| nameOverride | string | `""` | String to partially override openaev.fullname template (will maintain the release name) |
| networkPolicy | object | `{"egress":[],"enabled":false,"ingress":[],"policyTypes":[]}` | NetworkPolicy configuration </br> Ref: https://kubernetes.io/docs/concepts/services-networking/network-policies/ |
| networkPolicy.enabled | bool | `false` | Enable or disable NetworkPolicy |
| networkPolicy.policyTypes | list | `[]` | Policy types |
| nodeSelector | object | `{}` | Node labels for pod assignment </br> Ref: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector |
| opensearch | object | `{"enabled":true,"opensearchJavaOpts":"-Xmx512M -Xms512M","persistence":{"enabled":false},"singleNode":true}` | OpenSearch subchart deployment </br> Ref: https://github.com/opensearch-project/helm-charts/blob/main/charts/opensearch/values.yaml |
| opensearch.enabled | bool | `true` | Enable or disable OpenSearch subchart |
| podAnnotations | object | `{}` | Configure annotations on Pods |
| podDisruptionBudget | object | `{"enabled":false,"maxUnavailable":1}` | Pod Disruption Budget </br> Ref: https://kubernetes.io/docs/reference/kubernetes-api/policy-resources/pod-disruption-budget-v1/ |
| podLabels | object | `{}` | Configure labels on Pods |
| podSecurityContext | object | `{}` | Defines privilege and access control settings for a Pod </br> Ref: https://kubernetes.io/docs/concepts/security/pod-security-standards/ </br> Ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/ |
| postgresql | object | `{"auth":{"database":"openaev","password":"ChangeMe","username":"user"},"enabled":true,"image":{"repository":"bitnamilegacy/postgresql","tag":"17.6.0-debian-12-r4"},"primary":{"persistence":{"enabled":false}},"replicaCount":1}` | PostgreSQL subchart deployment </br> Ref: https://github.com/bitnami/charts/blob/main/bitnami/postgresql/values.yaml |
| postgresql.enabled | bool | `true` | Enable or disable PostgreSQL subchart |
| rabbitmq | object | `{"auth":{"erlangCookie":"ChangeMe","password":"ChangeMe","username":"user"},"clustering":{"enabled":false},"enabled":true,"global":{"security":{"allowInsecureImages":true}},"image":{"repository":"bitnamilegacy/rabbitmq","tag":"4.1.2-debian-12-r1"},"persistence":{"enabled":false},"replicaCount":1}` | RabbitMQ subchart deployment </br> Ref: https://github.com/bitnami/charts/blob/main/bitnami/rabbitmq/values.yaml |
| rabbitmq.enabled | bool | `true` | Enable or disable RabbitMQ subchart |
| readinessProbe | object | `{"enabled":true,"failureThreshold":3,"initialDelaySeconds":10,"periodSeconds":10,"successThreshold":1,"timeoutSeconds":1}` | Configure readinessProbe checker </br> Ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-startup-probes |
| readinessProbeCustom | object | `{}` | Custom readinessProbe |
| readyChecker | object | `{"enabled":false,"pullPolicy":"IfNotPresent","repository":"busybox","retries":30,"services":[{"name":"minio","port":9000},{"name":"postgresql","port":5432},{"name":"rabbitmq","port":5672}],"tag":"latest","timeout":5}` | Enable or disable ready-checker |
| readyChecker.enabled | bool | `false` | Enable or disable ready-checker |
| readyChecker.pullPolicy | string | `"IfNotPresent"` | Pull policy for the image |
| readyChecker.repository | string | `"busybox"` | Repository of the image |
| readyChecker.retries | int | `30` | Number of retries before giving up |
| readyChecker.services | list | `[{"name":"minio","port":9000},{"name":"postgresql","port":5432},{"name":"rabbitmq","port":5672}]` | List services |
| readyChecker.tag | string | `"latest"` | Overrides the image tag |
| readyChecker.timeout | int | `5` | Timeout for each check |
| replicaCount | int | `1` | Number of replicas for the service |
| resources | object | `{}` | The resources limits and requested </br> Ref: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ |
| secrets | list | `[]` | Secrets values to create credentials and reference by envFromSecrets Generate Secret with following name: <release-name>-<name> </br> Ref: https://kubernetes.io/docs/concepts/configuration/secret/ |
| securityContext | object | `{}` | Defines privilege and access control settings for a Container </br> Ref: https://kubernetes.io/docs/concepts/security/pod-security-standards/ </br> Ref: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/ |
| service | object | `{"annotations":{},"appProtocol":"HTTP","extraPorts":[],"labels":{},"loadBalancer":{},"port":80,"portName":"http","protocol":"TCP","targetPort":8080,"type":"ClusterIP"}` | Kubernetes service to expose Pod </br> Ref: https://kubernetes.io/docs/concepts/services-networking/service/ |
| service.annotations | object | `{}` | Annotations for the service |
| service.appProtocol | string | `"HTTP"` | Application protocol (HTTP, HTTPS, etc.) |
| service.extraPorts | list | `[]` | Pod extra ports |
| service.labels | object | `{}` | Additional labels for the service |
| service.loadBalancer | object | `{}` | LoadBalancer specific configuration |
| service.port | int | `80` | Kubernetes Service port |
| service.portName | string | `"http"` | Name for the service port |
| service.protocol | string | `"TCP"` | Protocol for the service port |
| service.targetPort | int | `8080` | Pod expose port |
| service.type | string | `"ClusterIP"` | Kubernetes Service type. Allowed values: NodePort, LoadBalancer, ClusterIP, ExternalName |
| serviceAccount | object | `{"annotations":{},"automountServiceAccountToken":false,"create":true,"name":""}` | Enable creation of ServiceAccount |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.automountServiceAccountToken | bool | `false` | Specifies if you don't want the kubelet to automatically mount a ServiceAccount API credentials |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | Name of the service account to use. If not set and create is true, a name is generated using the fullname template |
| startupProbe | object | `{"enabled":true,"failureThreshold":30,"initialDelaySeconds":180,"periodSeconds":10,"successThreshold":1,"timeoutSeconds":5}` | Configure startupProbe checker </br> Ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-startup-probes |
| startupProbeCustom | object | `{}` | Custom startupProbe |
| strategy | object | `{}` | Configure strategy for the deployment |
| terminationGracePeriodSeconds | int | `30` | Configure Pod termination grace period </br> Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#pod-termination |
| testConnection | bool | `false` | Enable or disable test connection |
| tolerations | list | `[]` | Tolerations for pod assignment </br> Ref: https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/ |
| topologySpreadConstraints | list | `[]` | Control how Pods are spread across your cluster </br> Ref: https://kubernetes.io/docs/concepts/scheduling-eviction/topology-spread-constraints/#example-multiple-topologyspreadconstraints |
| volumeMounts | list | `[]` | Additional volumeMounts on the output Deployment definition |
| volumes | list | `[]` | Additional volumes on the output Deployment definition |
