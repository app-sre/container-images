FROM quay.io/app-sre/qontract-reconcile-base:0.14.0@sha256:bd6f0de349fab0cce58ba9e5b0f01296688f26038b1ac3730b04eb8c270e255c as base

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
