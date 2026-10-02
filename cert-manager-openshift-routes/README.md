## cert-manager-openshift-routes - FIPS Red Hat Hardened Image Build

---

This Dockerfile repackages the cert-manager OpenShift Routes controller on the Red Hat FIPS-compliant core-runtime Hardened Base-Image. It copies the controller binary from the upstream GHCR image. It does not rebuild from source.

Upstream source: [https://github.com/cert-manager/openshift-routes](https://github.com/cert-manager/openshift-routes)

---

## Quick Start

```bash
# Build the image
make build

# Test it works
make test
```

---

## Updating to a New Version

Follow these steps to update the exporter version:

1. Edit `Dockerfile` and change the image tags.
  For the Red Hat base image:
  - Replace the `FIPS_IMAGE_TAG` with the version you want from [RH Hardened Core-Runtime FIPS releases](https://images.redhat.com/?fipsOnly=true&name=core-runtime&tab=tags).
  ```dockerfile
  FROM registry.access.redhat.com/hi/core-runtime:<FIPS_IMAGE_TAG>
  ```
  For the upstream exporter:
  - Replace `IMAGE_TAG` with the version you want from [cert-manager-openshift-routes releases](https://github.com/prometheus/cloudwatch_exporter/releases).
  ```dockerfile
  COPY --from=ghcr.io/cert-manager/cert-manager-openshift-routes:<IMAGE_TAG>
  ```
2. Rebuild the image:
  ```bash
   make build
  ```
3. Test the new build:
  ```bash
   make test
  ```

---



## Testing

`make test` runs two smoke tests. No cluster is required.

### Test A: `--help` flag

The test runs the binary with `--help`. It expects exit code 0 and usage output on stdout. This confirms the binary is present, executable, and the CLI flag wiring works.

### Test B: No kubeconfig

The test runs the binary with no kubeconfig and no in-cluster config. The binary contacts `http://localhost:8080` by default, fails to reach the API server, and exits non-zero. The test checks the output for `couldn't check if route.openshift.io/v1 exists in the kubernetes API`. A crash or missing binary produces different output and causes the test to fail.

---

## Manual Testing

Build the image:

```bash
podman build -f Dockerfile -t localhost/cert-manager-openshift-routes-fips-hb:testing .
```

Test the `--help` flag:

```bash
podman run --rm localhost/cert-manager-openshift-routes-fips-hb:testing --help
```

Test the startup failure (expected without a cluster):

```bash
podman run --rm localhost/cert-manager-openshift-routes-fips-hb:testing
```

Test with a real kubeconfig:

```bash
podman run --rm \
  -v ~/.kube/config:/home/nonroot/.kube/config:ro \
  localhost/cert-manager-openshift-routes-fips-hb:testing
```

---



## Files

- `Dockerfile` - FIPS-compliant build using the Red Hat Hardened Base-Image
- `Makefile` - Build and test automation

---



## Differences from Upstream


| Aspect        | Upstream                       | This Build                                          |
| ------------- | ------------------------------ | --------------------------------------------------- |
| Base image    | `quay.io/jetstack/base-static` | `registry.access.redhat.com/hi/core-runtime` (FIPS) |
| FIPS mode     | No                             | Yes (OpenSSL FIPS)                                  |
| Binary source | Built from source via ko       | Copied from upstream GHCR image                     |
| Behavior      | —                              | Identical                                           |


The application behavior is identical.