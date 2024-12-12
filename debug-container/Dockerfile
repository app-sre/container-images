# Locking this to a specific Fedora version for now. New releases of Postgresql, and Fedora versions going out of
# support will drive this upgrade every 6-12 months.
FROM quay.io/fedora/fedora:42

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
