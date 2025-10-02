FROM quay.io/redhat-services-prod/app-sre-tenant/container-images-master/qontract-reconcile-base-master:1.2.0-1@sha256:acce400b64894aa8afe7a269f6d991217edb168008f9a7b0533f71c3ba556711 AS base

LABEL konflux.additional-tags=1.2.0
WORKDIR /work

RUN mkdir ~/.gnupg && \
    echo no-user-agent > ~/.gnupg/gpg.conf && \
    microdnf upgrade -y && \
    microdnf install -y \
    gcc \
    gcc-c++ \
    libpq-devel \
    make && \
    microdnf clean all
