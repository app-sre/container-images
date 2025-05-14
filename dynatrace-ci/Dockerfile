FROM registry.access.redhat.com/ubi9-minimal@sha256:92b1d5747a93608b6adb64dfd54515c3c5a360802db4706765ff3d8470df6290 as terraform

USER 0

# Terraform versions and other related variables
ENV TF_VERSION="1.6.6" \
    TF_PLUGIN_CACHE_DIR=/plugins/ \
    TF_PLUGIN_CACHE_MAY_BREAK_DEPENDENCY_LOCK_FILE=true

# Install dependencies
RUN microdnf -y --nodocs --setopt=install_weak_deps=0 install unzip && \
    microdnf clean all && \
    rm -rf /mnt/rootfs/var/cache/* /mnt/rootfs/var/log/dnf* /mnt/rootfs/var/log/yum.*

# Install Terraform
RUN curl -sfL https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip \
    -o terraform.zip && \
    unzip terraform.zip && \
    mv terraform /usr/local/bin/terraform && \
    rm terraform.zip

RUN mkdir -p ${TF_PLUGIN_CACHE_DIR} && chown 1001:0 ${TF_PLUGIN_CACHE_DIR}

COPY providers.tf .

RUN terraform providers mirror -platform=linux_amd64 /plugins

# We want to be able to pull tf modules from internal repos
FROM quay.io/app-sre/internal-redhat-ca:0.3.0 as prod

WORKDIR /terraform

# We need git to fetch tf modules from git source
RUN microdnf -y install diffutils  git &&\
    microdnf clean all
COPY entrypoint.sh /usr/local/bin/
COPY --chown=0:0 --from=terraform /usr/local/bin/terraform /usr/local/bin/
COPY --chown=0:0 --from=terraform /plugins/ /plugins/

ENTRYPOINT ["entrypoint.sh"]

