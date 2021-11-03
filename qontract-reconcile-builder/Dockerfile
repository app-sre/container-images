FROM registry.access.redhat.com/ubi8/ubi:8.4 AS downloader

WORKDIR /work

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -L https://get.helm.sh/helm-v3.6.2-linux-amd64.tar.gz | tar xvz && \
    mv linux-amd64/helm /usr/local/bin/helm


FROM quay.io/app-sre/qontract-reconcile-base:0.6.2 as base

WORKDIR /work

COPY --from=downloader /usr/local/bin/helm /usr/local/bin/

RUN chmod +x /usr/local/bin/helm && \
    mkdir ~/.gnupg && \
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
