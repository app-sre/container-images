FROM quay.io/redhat-services-prod/app-sre-tenant/container-images-master/qontract-reconcile-base-master:1.5.0-1@sha256:792cb39465e78c46859ec937125fb397323e0b0044d19c2548d008b9fc9d54fd

LABEL konflux.additional-tags=1.5.0
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
