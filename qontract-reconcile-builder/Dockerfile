FROM quay.io/redhat-services-prod/app-sre-tenant/container-images-master/qontract-reconcile-base-master:2.2.1-1@sha256:80eea44e24eec0e772d16c492e3b8d9ec0030e8271536214921278cf66cfd4ff

LABEL konflux.additional-tags=2.2.1
WORKDIR /work

RUN mkdir ~/.gnupg && \
    echo no-user-agent > ~/.gnupg/gpg.conf && \
    microdnf upgrade -y && \
    microdnf install -y \
    gcc \
    gcc-c++ \
    libpq-devel \
    make && \
    microdnf clean all
