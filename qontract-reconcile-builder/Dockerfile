FROM quay.io/app-sre/qontract-reconcile-base:0.8.3 as base

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
        make \
        openssl \
        python39 \
        python3{,9}-devel && \
    microdnf clean all && \
    update-alternatives --set python3 /usr/bin/python3.9
