ARG TERRAFORM_REPO="quay.io/app-sre/terraform"
ARG TERRAFORM_VERSION="1.4.6"

FROM ${TERRAFORM_REPO}:${TERRAFORM_VERSION} as terraform

COPY providers.tf .
RUN terraform providers mirror -platform=linux_amd64 /plugins

FROM registry.access.redhat.com/ubi9/ubi-minimal:9.2@sha256:c8c7a06ce1c5fa23c1cbd7a0fd891eacd099bc232aa9985ddb183cfe98d1deaf

WORKDIR /terraform

RUN microdnf -y install diffutils &&\
    microdnf clean all

COPY --chown=0:0 --from=terraform /bin/terraform /usr/local/bin/
COPY --chown=0:0 --from=terraform /plugins/ /plugins/

