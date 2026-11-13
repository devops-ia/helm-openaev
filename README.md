# OpenAEV Helm Chart

[OpenAEV](https://github.com/OpenAEV-Platform/openaev) is an open source platform allowing organizations to plan, schedule and conduct cyber adversary simulation campaign and tests.

## Usage

Charts are available in:

* [Chart Repository](https://helm.sh/docs/topics/chart_repository/)
* [OCI Artifacts](https://helm.sh/docs/topics/registries/)

### Chart Repository

#### Add repository

```console
helm repo add openaev https://devops-ia.github.io/helm-openaev
helm repo update
```

#### Install Helm chart

```console
helm install [RELEASE_NAME] openaev/openaev
```

This install all the Kubernetes components associated with the chart and creates the release.

_See [helm install](https://helm.sh/docs/helm/helm_install/) for command documentation._

### OCI Registry

Charts are also available in OCI format. The list of available charts can be found [here](https://github.com/devops-ia/helm-openaev/pkgs/container/helm-openaev%2Fopenaev).

#### Install Helm chart

```console
helm install [RELEASE_NAME] oci://ghcr.io/devops-ia/helm-openaev/openaev --version=[version]
```

## OpenAEV chart

Can be found in [openaev chart](https://github.com/devops-ia/helm-openaev/tree/main/charts/openaev).
