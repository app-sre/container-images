# k8s-sidecar (Hummingbird FIPS)

Compliance replacement for [quay.io/kiwigrid/k8s-sidecar](https://quay.io/repository/kiwigrid/k8s-sidecar). The runtime image uses the [Red Hat Hummingbird Python FIPS](https://hummingbird-project.io/docs/using/overview/#fips-variants-latest-fips-latest-fips-builder) hardened image (`registry.access.redhat.com/hi/python`) instead of Alpine.

FIPS-validated cryptography applies when the container runs on a host in FIPS mode, per Hummingbird documentation.

## Purpose

This build repackages the upstream sidecar application onto a hardened, distroless **FIPS** Python base. It is intended as a compliance-friendly alternative to pulling `kiwigrid/k8s-sidecar` directly.

At **build time** the Dockerfile:

1. **`COPY --from=quay.io/kiwigrid/k8s-sidecar:…`** the four application modules into the builder stage (no `FROM` that Quay image — Konflux base-image policy rejects that; same approach as `prometheus-cloudwatch-exporter`).
2. Installs Python dependencies into a new venv on **`hi/python:<version>-fips-builder`** (glibc wheels; the upstream Alpine venv is not reused).
3. Produces a final image on **`hi/python:<version>-fips`** (distroless FIPS runtime).

Permitted **bases** for Konflux policy are the `registry.access.redhat.com/hi/python` stages only. Upstream Quay is a **copy source**, not a base image layer in the final manifest.

Sidecar behavior, environment variables, and probes are documented in the [upstream README](https://github.com/kiwigrid/k8s-sidecar/blob/master/README.md).

## Build arguments

| Argument       | Default   | Meaning                                      |
|----------------|-----------|----------------------------------------------|
| `SIDECAR_TAG`  | `1.30.11` | Konflux label `konflux.additional-tags`; must match the tag in the `COPY --from=quay.io/kiwigrid/k8s-sidecar:…` line in the Dockerfile |
| `PYTHON_TAG`   | `3.14`    | Python stream for `hi/python:${PYTHON_TAG}-fips-builder` and `hi/python:${PYTHON_TAG}-fips` |

Pick FIPS tags from the [Red Hat Hardened Images catalog](https://images.redhat.com/?fipsOnly=true&name=python) when bumping versions.

## Local build

Log in to Red Hat registry and ensure the build host can pull `quay.io/kiwigrid/k8s-sidecar`:

```bash
podman login registry.access.redhat.com
cd k8s-sidecar
podman build --platform linux/amd64 -f Dockerfile -t localhost/k8s-sidecar-hb:local .
```

Override versions:

```bash
podman build --platform linux/amd64 \
  --build-arg SIDECAR_TAG=1.30.11 \
  --build-arg PYTHON_TAG=3.14 \
  -f Dockerfile -t localhost/k8s-sidecar-hb:local .
```

For production, pin `hi/python` FIPS images by digest as described in the [Hummingbird docs](https://hummingbird-project.io/docs/using/overview/#referencing-images-in-production).
