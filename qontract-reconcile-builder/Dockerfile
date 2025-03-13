FROM quay.io/app-sre/qontract-reconcile-base:0.15.1@sha256:1024630e097f6eaee980218fdaeac609be597521c8e746131761ce8754ed5b54 as base

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
