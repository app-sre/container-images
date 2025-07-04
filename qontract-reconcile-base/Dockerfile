FROM registry.access.redhat.com/ubi9/ubi:9.5@sha256:d07a5e080b8a9b3624d3c9cfbfada9a6baacd8e6d4065118f0e80c71ad518044 AS downloader

RUN dnf -y install unzip glibc-langpack-en

ENV LC_ALL=en_US.utf8
ENV LANG=en_US.utf8

ENV TF_PROVIDER_AWS_VERSIONS="3.76.0 3.76.1 4.67.0 5.39.1"
ENV TF_PROVIDER_CLOUDFLARE_VERSIONS="3.32.0 4.26.0"
ENV TF_PROVIDER_RANDOM_VERSIONS="3.4.3"
ENV TF_PROVIDER_TIME_VERSIONS="0.9.1"
ENV TF_PROVIDER_CLOUDINIT_VERSIONS="2.3.3"
# be careful about changing OC version and consult with FT-3 to check with what OpenShift
# cluster versions are running as they differ from commercial
ENV OC_VERSION=4.12.46
ENV TF_VERSION=1.6.6
ENV HELM_VERSION=3.11.1
ENV GIT_SECRETS_VERSION=1.3.0
ENV PROMETHEUS_VERSIONS="2.55.1 3.2.1"
ENV ALERTMANAGER_VERSION=0.28.1


RUN for version in ${TF_PROVIDER_AWS_VERSIONS}; do \
    mkdir -p /tmp/terraform-providers/hashicorp/aws/${version}/linux_amd64 ;\
    curl -sfL https://releases.hashicorp.com/terraform-provider-aws/${version}/terraform-provider-aws_${version}_linux_amd64.zip \
    -o /tmp/package-aws-${version}.zip; \
    unzip /tmp/package-aws-${version}.zip -d /tmp/terraform-providers/hashicorp/aws/${version}/linux_amd64/; \
    done

RUN for version in ${TF_PROVIDER_CLOUDFLARE_VERSIONS}; do \
    mkdir -p /tmp/terraform-providers/cloudflare/cloudflare/${version}/linux_amd64 ;\
    curl -sfL https://github.com/cloudflare/terraform-provider-cloudflare/releases/download/v${version}/terraform-provider-cloudflare_${version}_linux_amd64.zip \
    -o /tmp/package-cloudflare-${version}.zip; \
    unzip /tmp/package-cloudflare-${version}.zip -d /tmp/terraform-providers/cloudflare/cloudflare/${version}/linux_amd64/; \
    done

RUN for version in ${TF_PROVIDER_TIME_VERSIONS}; do \
    mkdir -p /tmp/terraform-providers/hashicorp/time/${version}/linux_amd64 ;\
    curl -sfL https://releases.hashicorp.com/terraform-provider-time/${version}/terraform-provider-time_${version}_linux_amd64.zip \
    -o /tmp/package-time-${version}.zip; \
    unzip /tmp/package-time-${version}.zip -d /tmp/terraform-providers/hashicorp/time/${version}/linux_amd64/; \
    done

RUN for version in ${TF_PROVIDER_RANDOM_VERSIONS}; do \
    mkdir -p /tmp/terraform-providers/hashicorp/random/${version}/linux_amd64 ;\
    curl -sfL https://releases.hashicorp.com/terraform-provider-random/${version}/terraform-provider-random_${version}_linux_amd64.zip \
    -o /tmp/package-random-${version}.zip; \
    unzip /tmp/package-random-${version}.zip -d /tmp/terraform-providers/hashicorp/random/${version}/linux_amd64/; \
    done

RUN for version in ${TF_PROVIDER_CLOUDINIT_VERSIONS}; do \
    mkdir -p /tmp/terraform-providers/hashicorp/cloudinit/${version}/linux_amd64 ;\
    curl -sfL https://releases.hashicorp.com/terraform-provider-cloudinit/${version}/terraform-provider-cloudinit_${version}_linux_amd64.zip \
    -o /tmp/package-cloudinit-${version}.zip; \
    unzip /tmp/package-cloudinit-${version}.zip -d /tmp/terraform-providers/hashicorp/cloudinit/${version}/linux_amd64/; \
    done


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
RUN for version in ${PROMETHEUS_VERSIONS}; do \
    curl -sfL https://github.com/prometheus/prometheus/releases/download/v${version}/prometheus-${version}.linux-amd64.tar.gz \
    | tar -zxf - -C /usr/local/bin --strip-components=1 prometheus-${version}.linux-amd64/promtool && \
    mv /usr/local/bin/promtool /usr/local/bin/promtool-${version}; \
    done

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -sfL https://github.com/prometheus/alertmanager/releases/download/v${ALERTMANAGER_VERSION}/alertmanager-${ALERTMANAGER_VERSION}.linux-amd64.tar.gz \
    | tar -zxf - -C /usr/local/bin --strip-components=1 alertmanager-${ALERTMANAGER_VERSION}.linux-amd64/amtool


FROM registry.access.redhat.com/ubi9/ubi-minimal:9.5@sha256:a50731d3397a4ee28583f1699842183d4d24fadcc565c4688487af9ee4e13a44 as prod

LABEL konflux.additional-tags=1.0.0

ENV TF_PLUGIN_LOCAL_DIR=/usr/local/share/terraform/
ENV TF_PLUGIN_CACHE_DIR=/.terraform.d/plugin-cache/
ENV DEFAULT_PROMETHEUS_VERSION=2.55.1

# Terraform providers
COPY --chown=0:0 --from=downloader \
    /tmp/terraform-providers/ \
    ${TF_PLUGIN_LOCAL_DIR}/plugins/registry.terraform.io/

# Tooling binaries
COPY --chown=0:0 --from=downloader \
    /usr/local/bin/kubectl \
    /usr/local/bin/oc \
    /usr/local/bin/terraform \
    /usr/local/bin/helm \
    /usr/local/bin/git-secrets \
    /usr/local/bin/promtool* \
    /usr/local/bin/amtool \
    /usr/local/bin/

COPY switch-promtool /usr/local/bin/
RUN switch-promtool $DEFAULT_PROMETHEUS_VERSION

RUN mkdir -p ${TF_PLUGIN_CACHE_DIR} && \
    chmod 0775 ${TF_PLUGIN_CACHE_DIR} && \
    microdnf upgrade -y && \
    microdnf install -y \
        git \
        glibc-langpack-en \
        libpq \
        openssh-clients \
        openssl \
        python3.11 \
        skopeo \
        findutils && \
    microdnf update tzdata -y && \
    microdnf reinstall tzdata -y && \
    microdnf clean all && \
    update-alternatives --install /usr/bin/python3 python /usr/bin/python3.11 1 && \
    python3 -m ensurepip

RUN test -f /etc/localtime || ln -s /usr/share/zoneinfo/UTC /etc/localtime
ENV TZ=UTC
