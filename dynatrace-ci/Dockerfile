ARG TERRAFORM_REPO="quay.io/app-sre/terraform"
ARG TERRAFORM_VERSION="1.4.6"

FROM ${TERRAFORM_REPO}:${TERRAFORM_VERSION} as terraform

COPY providers.tf .
RUN terraform providers mirror -platform=linux_amd64 /plugins

FROM registry.access.redhat.com/ubi9/ubi-minimal:9.5-1731604394@sha256:46f77b7dfba47b041de4c9d8516c24081fc92cc7743fca4a353e7f1c2a4beb19

WORKDIR /terraform

RUN microdnf -y install diffutils &&\
    microdnf clean all

COPY --chown=0:0 --from=terraform /bin/terraform /usr/local/bin/
COPY --chown=0:0 --from=terraform /plugins/ /plugins/

