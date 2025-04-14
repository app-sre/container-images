# Build an AppSRE FedRamp-centric container for debugging issues (see git clone below)

# NOTE: postgres utils here are set to v14 by design

FROM quay.io/fedora/fedora:43@sha256:6949fc1c927bc4a9bf6ab81a995ac0f0f3bc69cdeeab2c90c42fb2b2906976ba
COPY --from=ghcr.io/astral-sh/uv:0.6.14@sha256:3362a526af7eca2fcd8604e6a07e873fb6e4286d8837cb753503558ce1213664 /uv /bin/uv


# since python tools are installed, install uv, see: 
ENV \
    UV_PYTHON="/usr/bin/python3.12" \
    # disable uv cache. it doesn't make sense in a container
    UV_NO_CACHE=true 

# FedRamp specific version number
ENV OCP_VERSION=4.14.45
ENV OCP_URL=https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OCP_VERSION}/openshift-client-linux-${OCP_VERSION}.tar.gz
    

RUN dnf -y --refresh --security upgrade && \
    dnf -y install \
        alternatives \
        bind-utils \
        community-mysql \
        curl \
        dnf-utils \
        dracut \
        git \
        htop \
        iputils \
        mtr \
        net-tools \
        nmap \
        openssl \
        perf \
        postgresql \
        procps-ng \
        python3-pip \
        redis \
        rsync \
        skopeo \
        strace \
        tar \
        tcpdump \
        telnet \
        tmux \
        traceroute \
    && dnf clean all

   
RUN dnf -y config-manager --add-repo https://download.postgresql.org/pub/repos/yum/13/redhat/rhel-9.2-x86_64 \
 && dnf -y config-manager --add-repo https://download.postgresql.org/pub/repos/yum/14/redhat/rhel-9.2-x86_64 \
 && dnf -y config-manager --add-repo https://download.postgresql.org/pub/repos/yum/15/redhat/rhel-9.2-x86_64 \
 && dnf -y config-manager --add-repo https://download.postgresql.org/pub/repos/yum/16/redhat/rhel-9.2-x86_64 \
 && dnf update -y \
 && dnf repolist \
 && dnf -y module disable postgresql

RUN dnf -y --nogpgcheck install postgresql13 \ 
                                postgresql14 \
                                postgresql15 \
                                postgresql16 \
 && dnf clean all

RUN export PGSSLCIPHERS='TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_GCM_SHA256:scram-sha-256'
RUN export OPENSSL_FIPS=1


RUN alternatives --install /usr/bin/psql psql /usr/pgsql-13/bin/psql 130 && \
    alternatives --install /usr/bin/psql psql /usr/pgsql-14/bin/psql 140 && \
    alternatives --install /usr/bin/psql psql /usr/pgsql-15/bin/psql 150 && \
    alternatives --install /usr/bin/psql psql /usr/pgsql-16/bin/psql 160 && \
    alternatives --install /usr/bin/psql psql /usr/pgsql-16/bin/psql 170 

RUN chmod -R 775 /var/lib/alternatives/ 
RUN chmod -R 775 /etc/alternatives/ 


RUN uv tool install awscli redis python3-PyMySQL python3-psycopg2


ENV PS1="\[\e[31m\]\[\e[0m\]\ndebug-fedramp\[\e[0;32m\]\u\[\e[m\]@\[\e[0;33m\]\h\[\e[m\]:\[\e[0;34m\]\w\[\e[m\] \$ "

USER 0

