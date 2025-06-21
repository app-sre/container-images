FROM quay.io/app-sre/qontract-reconcile-base:0.17.0@sha256:8be5ca513179b810ae63e9b3304081eae7b8bfb52ca401caa8f8dba0a0359c52 as base

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
