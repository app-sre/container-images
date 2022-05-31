FROM registry.access.redhat.com/ubi8/ubi:8.4 AS downloader

RUN dnf -y install unzip glibc-langpack-en

ENV LC_ALL=en_US.utf8
ENV LANG=en_US.utf8

ENV TF_PROVIDER_AWS_VERSIONS="3.22.0 3.30.0 3.75.2"
ENV TF_PROVIDER_RANDOM_VERSIONS="3.1.0"
ENV TF_PROVIDER_TIME_VERSIONS="0.7.2"
ENV TF_PROVIDER_TEMPLATE_VERSIONS="2.2.0"
ENV OC_VERSION=4.8.11
ENV TF_VERSION=0.13.7
ENV HELM_VERSION=3.6.2
ENV GIT_SECRETS_VERSION=1.3.0
ENV PROMETHEUS_VERSION=2.33.3
ENV ALERTMANAGER_VERSION=0.21.0


RUN for version in ${TF_PROVIDER_AWS_VERSIONS}; do \
    mkdir -p /tmp/terraform-providers/aws/${version}/linux_amd64 ;\
    curl -sfL https://releases.hashicorp.com/terraform-provider-aws/${version}/terraform-provider-aws_${version}_linux_amd64.zip \
    -o /tmp/package-aws-${version}.zip; \
    unzip /tmp/package-aws-${version}.zip -d /tmp/terraform-providers/aws/${version}/linux_amd64/; \
    done

RUN for version in ${TF_PROVIDER_TIME_VERSIONS}; do \
    mkdir -p /tmp/terraform-providers/time/${version}/linux_amd64 ;\
    curl -sfL https://releases.hashicorp.com/terraform-provider-time/${version}/terraform-provider-time_${version}_linux_amd64.zip \
    -o /tmp/package-time-${version}.zip; \
    unzip /tmp/package-time-${version}.zip -d /tmp/terraform-providers/time/${version}/linux_amd64/; \
    done

RUN for version in ${TF_PROVIDER_RANDOM_VERSIONS}; do \
    mkdir -p /tmp/terraform-providers/random/${version}/linux_amd64 ;\
    curl -sfL https://releases.hashicorp.com/terraform-provider-random/${version}/terraform-provider-random_${version}_linux_amd64.zip \
    -o /tmp/package-random-${version}.zip; \
    unzip /tmp/package-random-${version}.zip -d /tmp/terraform-providers/random/${version}/linux_amd64/; \
    done

RUN for version in ${TF_PROVIDER_TEMPLATE_VERSIONS}; do \
    mkdir -p /tmp/terraform-providers/template/${version}/linux_amd64 ;\
    curl -sfL https://releases.hashicorp.com/terraform-provider-template/${version}/terraform-provider-template_${version}_linux_amd64.zip \
    -o /tmp/package-template-${version}.zip; \
    unzip /tmp/package-template-${version}.zip -d /tmp/terraform-providers/template/${version}/linux_amd64/; \
    done

RUN dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    curl -sfL https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/CentOS_8/devel:kubic:libcontainers:stable.repo \
    -o /etc/yum.repos.d/devel:kubic:libcontainers:stable.repo && \
    dnf install -y skopeo && \
    dnf clean all

RUN curl -sfL https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OC_VERSION}/openshift-client-linux.tar.gz \
    -o oc.tar.gz && \
    tar -zvxf oc.tar.gz && \
    mv oc kubectl /usr/local/bin && \
    rm oc.tar.gz

RUN curl -sfL https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip \
    -o terraform.zip && \
    unzip terraform.zip && \
    mv terraform /usr/local/bin/terraform && \
    rm terraform.zip

RUN curl -L https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz | tar xvz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm

RUN curl -sfL https://github.com/awslabs/git-secrets/archive/${GIT_SECRETS_VERSION}.tar.gz \
    -o git-secrets.tar.gz && \
    tar -zvxf git-secrets.tar.gz git-secrets-${GIT_SECRETS_VERSION}/git-secrets && \
    mv git-secrets-${GIT_SECRETS_VERSION}/git-secrets /usr/local/bin/git-secrets && \
    chmod 0755 /usr/local/bin/git-secrets && \
    rm -rf git-secrets*

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -sfL https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz \
    | tar -zxf - -C /usr/local/bin --strip-components=1 prometheus-${PROMETHEUS_VERSION}.linux-amd64/promtool

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -sfL https://github.com/prometheus/alertmanager/releases/download/v${ALERTMANAGER_VERSION}/alertmanager-${ALERTMANAGER_VERSION}.linux-amd64.tar.gz \
    | tar -zxf - -C /usr/local/bin --strip-components=1 alertmanager-${ALERTMANAGER_VERSION}.linux-amd64/amtool


FROM registry.access.redhat.com/ubi8/ubi-minimal:8.4

ENV TF_PLUGIN_LOCAL_DIR=/usr/local/share/terraform/
ENV TF_PLUGIN_CACHE_DIR=/.terraform.d/plugin-cache/

# Terraform providers
COPY --chown=0:0 --from=downloader \
    /tmp/terraform-providers/ \
    ${TF_PLUGIN_LOCAL_DIR}/plugins/registry.terraform.io/hashicorp/

# Tooling binaries
COPY --chown=0:0 --from=downloader \
    /usr/local/bin/kubectl \
    /usr/local/bin/oc \
    /usr/local/bin/terraform \
    /usr/local/bin/helm \
    /usr/local/bin/git-secrets \
    /usr/local/bin/promtool \
    /usr/local/bin/amtool \
    /usr/bin/skopeo \
    /usr/local/bin/

RUN mkdir -p ${TF_PLUGIN_CACHE_DIR} && \
    chmod 0775 ${TF_PLUGIN_CACHE_DIR} && \
    microdnf upgrade -y && \
    microdnf install \
        git \
        glibc-langpack-en \
        openssh-clients \
        openssl \
        python3.9 \
        skopeo \
        findutils && \
    microdnf clean all
