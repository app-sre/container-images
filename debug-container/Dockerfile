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
