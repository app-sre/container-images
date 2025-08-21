FROM quay.io/redhat-services-prod/app-sre-tenant/container-images-master/qontract-reconcile-base-master:1.1.0-1@sha256:095e6d5b029b561dd6f3d4394c691852bb96cc8587ebbc5092463b8d101893b8 as base

LABEL konflux.additional-tags=1.1.0
WORKDIR /work

RUN mkdir ~/.gnupg && \
    echo no-user-agent > ~/.gnupg/gpg.conf && \
    microdnf upgrade -y && \
    microdnf install -y \
        gcc \
        gcc-c++ \
        glibc-langpack-en \
        git \
        gnupg2 \
        libpq-devel \
        make \
        openssl \
        python3.11-devel && \
    microdnf clean all
