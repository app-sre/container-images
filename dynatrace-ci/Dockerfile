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
FROM registry.access.redhat.com/ubi9/ubi-minimal:9.4 AS internal-CA-builder

ENV INTERNAL_CA_FILENAME="redhat-internal-cert-install-0.1-31.el7.noarch.rpm"
ENV INTERNAL_CA_URL="http://hdn.corp.redhat.com/rhel8-csb/RPMS/noarch/"$INTERNAL_CA_FILENAME

RUN microdnf install -y wget java-headless chkconfig && \
    wget $INTERNAL_CA_URL && \
    rpm -i $INTERNAL_CA_FILENAME

FROM registry.access.redhat.com/ubi9/ubi-minimal:9.4

LABEL konflux.additional-tags="0.5.0"

COPY LICENSE /licenses/LICENSE

COPY --from=internal-CA-builder /etc/pki/ /etc/pki/

WORKDIR /terraform

# We need git to fetch tf modules from git source
RUN microdnf -y install jq diffutils  git &&\
    microdnf clean all

COPY entrypoint.sh /usr/local/bin/
COPY --chown=0:0 --from=terraform /usr/local/bin/terraform /usr/local/bin/
COPY --chown=0:0 --from=terraform /plugins/ /plugins/

ENTRYPOINT ["entrypoint.sh"]

