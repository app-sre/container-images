FROM quay.io/redhat-services-prod/app-sre-tenant/container-images-master/qontract-reconcile-base-master:1.3.0-1@sha256:89b976c5e29a0ec233485fb473867f31ff7dec840419236f63ac8ef7b585cc9a AS base

LABEL konflux.additional-tags=1.3.0
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
