FROM registry.access.redhat.com/ubi9/ubi:9.8-1789646010@sha256:9295c5c688f487fa5cf27a734fa55ecd57aeb7dc0904ba537da4f42dfa1d0acb

LABEL konflux.additional-tags=0.4.2

# Enable required repositories
RUN dnf module enable -y redis:7

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
        redis \
        rsync \
        skopeo \
        socat \
        strace \
        tar \
        vim \
    && dnf clean all


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

# Copy telnet wrapper script (uses nc since telnet package is not available in UBI9 repositories)
COPY telnet /usr/local/bin/telnet
RUN chmod +x /usr/local/bin/telnet
