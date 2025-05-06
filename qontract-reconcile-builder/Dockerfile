FROM quay.io/app-sre/qontract-reconcile-base:0.15.4@sha256:a946d3980b8c8acc10ad0877f4c04a5a473397bc332159685dc1bfd55ea0ac08 as base

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
