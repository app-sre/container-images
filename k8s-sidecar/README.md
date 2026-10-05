# k8s-sidecar (Hummingbird)

Compliance replacement for [quay.io/kiwigrid/k8s-sidecar](https://quay.io/repository/kiwigrid/k8s-sidecar). The runtime image uses [Red Hat Hummingbird Python](https://hummingbird-project.io/docs/using/overview/) (`registry.access.redhat.com/hi/python`) instead of Alpine.

## Purpose

This build repackages the upstream sidecar application onto a hardened, distroless Python base. It is intended as a compliance-friendly alternative to pulling `kiwigrid/k8s-sidecar` directly.

At **build time** the Dockerfile:

1. Copies `/app/*.py` from `quay.io/kiwigrid/k8s-sidecar` (pinned by `SIDECAR_TAG`).
2. Installs Python dependencies into a new venv on `hi/python` **`-builder`** (glibc wheels; the upstream Alpine venv is not reused).
3. Produces a final image on **`hi/python`** (runtime variant only).

The **shipped image** is Hummingbird-based only; the Kiwi Grid image is not the runtime base.

Sidecar behavior, environment variables, and probes are documented in the [upstream README](https://github.com/kiwigrid/k8s-sidecar/blob/master/README.md).

## Build arguments

| Argument       | Default   | Meaning                                      |
|----------------|-----------|----------------------------------------------|
| `SIDECAR_TAG`  | `1.30.11` | Tag of `quay.io/kiwigrid/k8s-sidecar` to copy `.py` from |
| `PYTHON_TAG`   | `3.14`    | Hummingbird Python stream (`hi/python` and `hi/python-*-builder`) |

`LABEL konflux.additional-tags=${SIDECAR_TAG}` tags Konflux builds with the upstream sidecar version.

## Local build

Log in to Red Hat registry (Hummingbird bases) and ensure the build host can pull `quay.io/kiwigrid/k8s-sidecar`:

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

For production, pin `hi/python` by digest as described in the [Hummingbird docs](https://hummingbird-project.io/docs/using/overview/#referencing-images-in-production).
