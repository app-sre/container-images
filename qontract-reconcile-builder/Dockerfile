FROM quay.io/app-sre/qontract-reconcile-base:0.16.0@sha256:572236bc0a4a51aca1c35f72572b2e6808f8bc4c0e976e03952a52711c30a126 as base

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
