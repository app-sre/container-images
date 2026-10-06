ARG SIDECAR_TAG=1.30.11
ARG PYTHON_TAG=3.14
FROM registry.access.redhat.com/hi/python:${PYTHON_TAG}-fips-builder AS builder
ARG SIDECAR_TAG
USER root
WORKDIR /app
COPY --from=quay.io/kiwigrid/k8s-sidecar:1.30.11 \
    /app/helpers.py \
    /app/logger.py \
    /app/resources.py \
    /app/sidecar.py \
    /app/
RUN python -m venv .venv \
    && .venv/bin/pip install --no-cache-dir \
         kubernetes==32.0.1 \
         requests==2.33.1 \
         python-json-logger==4.1.0 \
         logfmter==0.0.12 \
         pyasn1==0.6.4
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
