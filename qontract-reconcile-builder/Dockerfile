FROM quay.io/redhat-services-prod/app-sre-tenant/container-images-master/qontract-reconcile-base-master:1.2.0-1 as base

LABEL konflux.additional-tags=1.2.0
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
        python3.12-devel && \
    microdnf clean all
