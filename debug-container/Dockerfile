# Locking this to a specific Fedora version for now. New releases of Postgresql, and Fedora versions going out of
# support will drive this upgrade every 6-12 months.
FROM quay.io/fedora/fedora:43.20250718.0

RUN dnf -y update && \
    dnf -y install \
        audit \
        bind-utils \
        bridge-utils \
        community-mysql \
        clang \
        crash \ 
        curl \
        ethtool \
        git \
        htop \
        iotop \
        iputils \
        iproute \
        jq \
        kdump-utils \
        kexec-tools \
        krb5-devel \
        libsysstat \
        ltrace \
        mtr \
        nethogs \
        net-tools \
        nmap \
        openssl \
        perf \
        postgresql \
        postgresql-contrib \
        procps-ng \
        python3-devel \
        python3-pip \
        python3-psycopg2 \
        python3-PyMySQL \
        redis \
        rsync \
        setroubleshoot \
        skopeo \
        strace \
        sysstat \
        tcpdump \
        telnet \
        tmux \
        traceroute \
        util-linux \
        yq \
    && dnf clean all

# Install some python packages using pip
RUN pip install awscli redis 

# Set the prompt to make it clear that this is a debug container
ENV PS1="\[\e[31m\]debug-container\[\e[0m\]\n\[\e[0;32m\]\u\[\e[m\]@\[\e[0;33m\]\h\[\e[m\]:\[\e[0;34m\]\w\[\e[m\] \$ "

# Copy our redis-cli wrapper script into the container. This script is used by automated-actions!
COPY redis-cli-ext /usr/local/bin/redis-cli-ext
