FROM quay.io/redhat-services-prod/app-sre-tenant/container-images-master/qontract-reconcile-base-master:2.2.0-1@sha256:918bc54441031f48f5b9c0b8f99c3ff3fb260aec1390bf5bbd79dbf020730e39

LABEL konflux.additional-tags=2.2.0
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
