ARG TERRAFORM_REPO="quay.io/app-sre/terraform"
ARG TERRAFORM_VERSION="1.4.6"

FROM ${TERRAFORM_REPO}:${TERRAFORM_VERSION} as terraform

COPY providers.tf .
RUN terraform providers mirror -platform=linux_amd64 /plugins

# We want to be able to pull tf modules from internal repos
FROM quay.io/app-sre/internal-redhat-ca:0.3.0

WORKDIR /terraform

# We need git to fetch tf modules from git source
RUN microdnf -y install diffutils  git &&\
    microdnf clean all
COPY entrypoint.sh /usr/local/bin/
COPY --chown=0:0 --from=terraform /bin/terraform /usr/local/bin/
COPY --chown=0:0 --from=terraform /plugins/ /plugins/

ENTRYPOINT ["entrypoint.sh"]

