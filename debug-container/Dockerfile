# Locking this to a specific UBI version for now. New releases of Postgresql, and UBI versions going out of
# support will drive this upgrade every 6-12 months.
FROM registry.access.redhat.com/ubi9/ubi:9.5@sha256:d07a5e080b8a9b3624d3c9cfbfada9a6baacd8e6d4065118f0e80c71ad518044

# Enable required repositories
RUN dnf -y update && \
    dnf -y install \
        bind-utils \
        mariadb \
        ethtool \
        file \
        gcc \
        gdb \
        git \
        iproute \
        iputils \
        jq \
        less \
        lsof \
        mtr \
        nano \
        net-tools \
        nmap \
        nmap-ncat \
        openssl \
        postgresql \
        procps-ng \
        python3-devel \
        python3-pip \
        python3-psycopg2 \
        python3-PyMySQL \
        rsync \
        skopeo \
        socat \
        strace \
        tar \
        vim \
    && dnf clean all

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/

# Install OpenShift CLI (oc) - adjust version as needed
ENV OC_VERSION=4.16.2
RUN curl -LO "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OC_VERSION}/openshift-client-linux.tar.gz" && \
    tar -xzf openshift-client-linux.tar.gz && \
    chmod +x oc kubectl && \
    mv oc kubectl /usr/local/bin/ && \
    rm -f openshift-client-linux.tar.gz

# Install Helm
ENV HELM_VERSION=3.19.2
RUN curl -LO "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" && \
    tar -xzf helm-v${HELM_VERSION}-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/ && \
    chmod +x /usr/local/bin/helm && \
    rm -rf linux-amd64 helm-v${HELM_VERSION}-linux-amd64.tar.gz

# Install Python packages for debugging and API testing
RUN pip install --no-cache-dir \
    awscli \
    redis \
    memray \
    py-spy \
    httpie \
    graphql-core \
    requests


# Set the prompt to make it clear that this is a debug container
RUN echo 'export PS1="\[\033[31m\]debug-container\[\033[0m\]\n\[\033[0;32m\]\u\[\033[m\]@\[\033[0;33m\]\h\[\033[m\]:\[\033[0;34m\]\w\[\033[m\] \$ "' >> /etc/bashrc

# Copy our redis-cli wrapper script into the container. This script is used by automated-actions!
COPY redis-cli-ext /usr/local/bin/redis-cli-ext
