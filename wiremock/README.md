# Wiremock

WireMock is an open-source tool primarily used for API mock testing. It simulates HTTP-based APIs, allowing you to create stable development and test environments.

This is especially useful for:
* Isolating your application from flaky or unreliable third-party APIs.
* Simulating APIs that are not yet built or are still in development.
* Creating stable environments for unit, integration, and end-to-end testing.

Docs: https://wiremock.org/docs/


## Example:

This will deploy a wiremock Pod configured with two routes:

```yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: wiremock
  name: wiremock
spec:
  containers:
  - image: quay.io/redhat-services-prod/app-sre-tenant/container-images-master/wiremock-master:latest
    name: wiremock
    resources: {}
    imagePullPolicy: IfNotPresent
    volumeMounts:
    - name: wiremock-mappings
      mountPath: /deployments/mappings
    volumeMounts:
    - name: wiremock-files
      mountPath: /deployments/__files
    livenessProbe:
      httpGet:
        path: /__admin/health
        port: 8080
      initialDelaySeconds: 10
      periodSeconds: 10
      timeoutSeconds: 5
      failureThreshold: 3
    readinessProbe:
      httpGet:
        path: /__admin/health
        port: 8080
  dnsPolicy: ClusterFirst
  restartPolicy: Always
  volumes:
  - name: wiremock-mappings
    configMap:
      name: wiremock-mappings
  - name: wiremock-files
    emptyDir: {}
---
apiVersion: v1
data:
  health-check.json: |
    {
      "request": {
        "method": "GET",
        "url": "/health"
      },
      "response": {
        "status": 200,
        "headers": {
          "Content-Type": "application/json"
        },
        "jsonBody": {
          "text": "OK",
          "status": "green"
        }
      }
    }
  hello-world.json: |
    {
      "request": {
        "method": "POST",
        "url": "/hello-world"
      },
      "response": {
        "status": 200,
        "headers": {
          "Content-Type": "application/json"
        },
        "jsonBody": {
          "text": "Hello, World!",
          "status": "green"
        }
      }
    }
kind: ConfigMap
metadata:
  name: wiremock-mappings
```
