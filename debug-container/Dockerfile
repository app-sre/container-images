# Locking this to a specific Fedora version for now. New releases of Postgresql, and Fedora versions going out of
# support will drive this upgrade every 6-12 months.
FROM quay.io/fedora/fedora:43@sha256:1683087f218c40df7ad0814942653a436e7e2a0c9f19b2d5a01481884a7c952b

RUN dnf -y update && \
    dnf -y install \
        bind-utils \
        community-mysql \
        curl \
        git \
        htop \
        iputils \
        mtr \
        net-tools \
        nmap \
        openssl \
        postgresql \
        procps-ng \
        python3-pip \
        python3-psycopg2 \
        python3-PyMySQL \
        redis \
        rsync \
        skopeo \
        strace \
        tcpdump \
        telnet \
        tmux \
        traceroute \
    && dnf clean all

# Install some python packages using pip
RUN pip install awscli redis

# Set the prompt to make it clear that this is a debug container
ENV PS1="\[\e[31m\]debug-container\[\e[0m\]\n\[\e[0;32m\]\u\[\e[m\]@\[\e[0;33m\]\h\[\e[m\]:\[\e[0;34m\]\w\[\e[m\] \$ "

# Copy our redis-cli wrapper script into the container. This script is used by automated-actions!
COPY redis-cli-ext /usr/local/bin/redis-cli-ext
