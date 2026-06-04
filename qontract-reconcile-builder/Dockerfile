FROM quay.io/redhat-services-prod/app-sre-tenant/container-images-master/qontract-reconcile-base-master:2.0.0-1@sha256:88fe57608407bbe48e96750858909bdcca1d305a26bfc8077ae32a11a7973008

LABEL konflux.additional-tags=2.0.0
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
