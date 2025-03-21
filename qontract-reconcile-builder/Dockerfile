FROM quay.io/app-sre/qontract-reconcile-base:0.15.3@sha256:3d5f101d10be2ba8b3b61276c19ef854e42a99b19c2a606163e97ad41bc43768 as base

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
