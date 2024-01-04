FROM registry.access.redhat.com/ubi9/ubi:9.2 AS downloader

# TODO: automatically keep in sync with target repo (fetch .tool-version?)
ENV TF_VERSION=1.4.6

RUN dnf -y install unzip

RUN curl -sfL https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip \
    -o terraform.zip && \
    unzip terraform.zip && \
    mv terraform /usr/local/bin/terraform && \
    rm terraform.zip


FROM registry.access.redhat.com/ubi9/ubi-minimal:9.2

# TODO: cache provider plugins

RUN mkdir /terraform
WORKDIR /terraform

# Tooling binaries
COPY --chown=0:0 --from=downloader \
    /usr/local/bin/terraform \
    /usr/local/bin/
