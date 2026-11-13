# Testing OpenAEV Helm Chart

This document provides guidelines for testing the OpenAEV Helm chart. Follow these instructions to ensure the chart works as expected before deployment to production.

## Steps

### 1. Lint Testing

```bash
# Run helm lint to check for any syntax issues
helm lint charts/openaev
```

### 2. Template Testing

```bash
# Generate and verify the template output
helm template openaev charts/openaev --debug
```

### 3. Local installation testing

```bash
# Install the chart in a test namespace
kubectl create namespace openaev-test
helm install openaev-test charts/openaev --namespace openaev-test \
  --values charts/openaev/ci/ci-standalone-values.yaml
```

### 4. Verification steps

1. Check all pods are running:

```bash
kubectl get pods -n openaev-test
```

2. Verify services are exposed:

```bash
kubectl get svc -n openaev-test
```

3. Check platform accessibility:

```bash
kubectl port-forward svc/openaev-test 8080:8080 -n openaev-test
```

4. Validate component health:

- OpenAEV platform UI accessibility
- OpenSearch connection
- PostgreSQL connection
- RabbitMQ status
- RustFS/S3 connectivity

### 5. Functional testing

1. **Platform login**
   - Verify the admin credentials work
   - Test SSO if configured

2. **Simulations**
   - Create a test scenario
   - Launch a simulation with a manual inject

3. **Integrations**
   - Check that the configured collectors and injectors register in the platform

### 6. Upgrade testing

```bash
# Test upgrade from previous version
helm upgrade openaev-test charts/openaev --namespace openaev-test
```

### 7. Clean-up

```bash
# Remove test deployment
helm uninstall openaev-test --namespace openaev-test
kubectl delete namespace openaev-test
```

## Automated testing

For CI/CD pipelines, you can use the following tools:

1. [Chart Testing](https://github.com/helm/chart-testing)
2. [Helm Unit Tests](https://github.com/helm-unittest/helm-unittest)

Example CI test command:

```bash
ct lint-and-install --config .github/ct.yaml
```
