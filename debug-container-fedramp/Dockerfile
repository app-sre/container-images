# Build an AppSRE FedRamp-centric container for debugging issues (see git clone below)

# NOTE: postgres utils here are set to v14 by design
FROM registry.access.redhat.com/ubi8/ubi:8.10

RUN dnf -y --refresh --security upgrade && \
    dnf config-manager --set-enabled ubi-8-baseos-rpms ubi-8-codeready-builder-rpms ubi-8-appstream-rpms && \
    dnf -y install dnf-utils \
        dracut \
        python3-pip \
        python3-PyMySQL \
        python3-psycopg2 \
        git \
        nmap \
        bind-utils \ 
        net-tools \
        rsync \
        skopeo \
        iputils \
        alternatives \
        perf

RUN dnf -y config-manager --add-repo https://download.postgresql.org/pub/repos/yum/13/redhat/rhel-8.8-x86_64 \
    && dnf -y config-manager --add-repo https://download.postgresql.org/pub/repos/yum/14/redhat/rhel-8.8-x86_64 \
    && dnf -y config-manager --add-repo https://download.postgresql.org/pub/repos/yum/15/redhat/rhel-8.8-x86_64 \
    && dnf -y config-manager --add-repo https://download.postgresql.org/pub/repos/yum/16/redhat/rhel-8.8-x86_64 \
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
    alternatives --install /usr/bin/psql psql /usr/pgsql-16/bin/psql 160 

RUN chmod -R 775 /var/lib/alternatives/ 
RUN chmod -R 775 /etc/alternatives/ 

RUN pip3 install awscli redis

ENV TERM=vt100

ENV PS1="\[\e[31m\]\[\e[0m\]\ndebug-fedramp\[\e[0;32m\]\u\[\e[m\]@\[\e[0;33m\]\h\[\e[m\]:\[\e[0;34m\]\w\[\e[m\] \$ "

USER 0

