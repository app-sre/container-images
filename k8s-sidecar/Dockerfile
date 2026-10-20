ARG SIDECAR_TAG=1.30.11
# git rev-parse refs/tags/${SIDECAR_TAG} on https://github.com/kiwigrid/k8s-sidecar
ARG SIDECAR_COMMIT_SHA=abcd49b72c42e36dd70483ae540d498449fcaefc
ARG PYTHON_TAG=3.14
FROM registry.access.redhat.com/hi/python:${PYTHON_TAG}-fips-builder AS builder
ARG SIDECAR_COMMIT_SHA
USER root
WORKDIR /app

# cryptography is a transitive dependency (kubernetes -> google-auth ->
# cryptography), not an app dependency we call directly. The default
# manylinux wheel bundles a statically-linked OpenSSL, bypassing
# Hummingbird's FIPS-validated OpenSSL provider even though nothing here
# invokes cryptography's crypto APIs. Build it from source instead so it
# links the image's system OpenSSL:
#   https://cryptography.io/en/latest/installation/#building-cryptography-on-linux
#   https://hummingbird-project.io/docs/contributing/fips-variant-guide/
RUN set -eux; \
    openssl_devel=$(rpm -q --queryformat 'openssl-devel-%{VERSION}-%{RELEASE}.%{ARCH}' openssl-libs); \
    dnf install -y gcc libffi-devel rust cargo pkg-config python3-devel git "${openssl_devel}"; \
    dnf clean all

RUN git clone https://github.com/kiwigrid/k8s-sidecar.git /tmp/k8s-sidecar \
    && cd /tmp/k8s-sidecar \
    && git checkout "${SIDECAR_COMMIT_SHA}" \
    && test "$(git rev-parse HEAD)" = "${SIDECAR_COMMIT_SHA}" \
    && cp -a src/. /app/

COPY check_cryptography_openssl.py /tmp/check_cryptography_openssl.py

RUN python -m venv .venv \
    && .venv/bin/pip install --no-cache-dir -U pip \
    && OPENSSL_NO_VENDOR=1 .venv/bin/pip install --no-cache-dir --no-binary cryptography \
         -r requirements.txt \
    && rm -f requirements.txt \
    && .venv/bin/python /tmp/check_cryptography_openssl.py
FROM registry.access.redhat.com/hi/python:${PYTHON_TAG}-fips
ARG SIDECAR_TAG
LABEL org.opencontainers.image.source=https://github.com/kiwigrid/k8s-sidecar
LABEL konflux.additional-tags=${SIDECAR_TAG}
ENV PYTHONUNBUFFERED=1
WORKDIR /app
COPY --from=builder /app /app
ENV PATH="/app/.venv/bin:$PATH"
USER 65534:65534
ENTRYPOINT ["python", "-u", "/app/sidecar.py"]
