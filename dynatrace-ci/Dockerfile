ARG TERRAFORM_REPO="quay.io/app-sre/terraform"
ARG TERRAFORM_VERSION="1.4.6"

FROM ${TERRAFORM_REPO}:${TERRAFORM_VERSION} as terraform

COPY providers.tf .
RUN terraform providers mirror -platform=linux_amd64 /plugins

FROM registry.access.redhat.com/ubi9/ubi:9.2

# TODO: dirty user hack for workspace mounting purposes -> make better
RUN useradd --uid 1001 -M jenkins
USER jenkins
WORKDIR /terraform

COPY --chown=0:0 --from=terraform /bin/terraform /usr/local/bin/
COPY --chown=0:0 --from=terraform /plugins/ /plugins/

