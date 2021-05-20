FROM registry.access.redhat.com/ubi8/ubi:8.2 AS terraform-providers-downloader

ENV VERSIONS="3.22.0 3.30.0"

RUN dnf -y install unzip; \
    cd /tmp/; rm -rf /tmp/terraform-* ; rm -rf /tmp/package-* ;\
    for version in ${VERSIONS}; do \
    mkdir -p /tmp/terraform-providers/${version}/linux_amd64 ;\
    curl -o /tmp/package-${version}.zip https://releases.hashicorp.com/terraform-provider-aws/${version}/terraform-provider-aws_${version}_linux_amd64.zip; \
    unzip /tmp/package-${version}.zip -d /tmp/terraform-providers/${version}/linux_amd64/; \
    done

FROM registry.access.redhat.com/ubi8/ubi:8.2

ENV LC_ALL=en_US.utf8
ENV LANG=en_US.utf8
ENV OC_VERSION=4.6.1
ENV TF_VERSION=0.13.7
ENV GIT_SECRETS_VERSION=1.3.0
ENV PROMETHEUS_VERSION=2.26.0
ENV ALERTMANAGER_VERSION=0.21.0
ENV TF_PLUGIN_LOCAL_DIR=/usr/local/share/terraform
ENV TF_PLUGIN_CACHE_DIR=/.terraform.d

RUN dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable.repo https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/CentOS_8/devel:kubic:libcontainers:stable.repo && \
    dnf install -y python3 python3-pip python3-devel git make tar gzip unzip gcc gcc-c++ openssh-clients openssl glibc-langpack-en && \
    dnf install -y skopeo && \
    python3 -m pip install --upgrade pip setuptools && \
    dnf clean all

RUN curl https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OC_VERSION}/openshift-client-linux.tar.gz -o oc.tar.gz &&\
    tar -zvxf oc.tar.gz && \
    mv oc kubectl /usr/local/bin && \
    rm oc.tar.gz

RUN curl https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip --output terraform.zip && \
    unzip terraform.zip && \
    mv terraform /usr/local/bin/terraform && \
    rm terraform.zip

RUN curl https://github.com/awslabs/git-secrets/archive/${GIT_SECRETS_VERSION}.tar.gz -L -o git-secrets.tar.gz && \
    tar -zvxf git-secrets.tar.gz git-secrets-${GIT_SECRETS_VERSION}/git-secrets && \
    mv git-secrets-${GIT_SECRETS_VERSION}/git-secrets /usr/local/bin/git-secrets && \
    rm -rf git-secrets*

RUN curl -sfL https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-amd64.tar.gz | tar -zxf - -C /usr/local/bin --strip-components=1 prometheus-${PROMETHEUS_VERSION}.linux-amd64/promtool

RUN curl -sfL https://github.com/prometheus/alertmanager/releases/download/v${ALERTMANAGER_VERSION}/alertmanager-${ALERTMANAGER_VERSION}.linux-amd64.tar.gz | tar -zxf - -C /usr/local/bin --strip-components=1 alertmanager-${ALERTMANAGER_VERSION}.linux-amd64/amtool

RUN mkdir -p ${TF_PLUGIN_CACHE_DIR}/plugin-cache
COPY --from=terraform-providers-downloader /tmp/terraform-providers/ ${TF_PLUGIN_LOCAL_DIR}/plugins/registry.terraform.io/hashicorp/aws/
RUN find ${TF_PLUGIN_LOCAL_DIR} -type d -exec chmod 0755 {} \;
RUN find ${TF_PLUGIN_CACHE_DIR} -type d -exec chmod 0775 {} \;
