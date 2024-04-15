# Build an AppSRE FedRamp-centric container for debugging issues (see git clone below)
# Do NOT install any version of OpenSSL as it will break other tools (ex: psql)
# NOTE: postgres utils here are set to v14 by design
FROM quay.io/fedora/fedora:39

RUN dnf -y --refresh --security upgrade && \
        dnf -y install https://download.postgresql.org/pub/repos/yum/reporpms/F-39-x86_64/pgdg-fedora-repo-latest.noarch.rpm \
        python3-pip \
        python3-PyMySQL \
        python3-psycopg2 \
        git \
        pcp \
        telnet \
        nmap \
        bind-utils \
        net-tools \
        curl \
        traceroute \
        mtr \
        tcpdump \
        community-mysql \
        rsync \
        skopeo \
        redis \
        tmux \
        iputils \
        htop \
        alternatives \
    && dnf clean all

RUN dnf -y install postgresql13 \
                   postgresql14 \
                   postgresql15 \
                   postgresql16 


RUN sudo alternatives --install /usr/bin/psql psql /usr/pgsql-13/bin/psql 130 && \
    sudo alternatives --install /usr/bin/psql psql /usr/pgsql-14/bin/psql 140 && \
    sudo alternatives --install /usr/bin/psql psql /usr/pgsql-15/bin/psql 150 && \
    sudo alternatives --install /usr/bin/psql psql /usr/pgsql-16/bin/psql 160 

RUN chmod -R 775 /var/lib/alternatives/ 

RUN git clone --depth 1 https://github.com/brendangregg/perf-tools

RUN pip install awscli redis

ENV TERM=vt100

ENV PS1="\[\e[31m\]\[\e[0m\]\ndebug-fedramp\[\e[0;32m\]\u\[\e[m\]@\[\e[0;33m\]\h\[\e[m\]:\[\e[0;34m\]\w\[\e[m\] \$ "

USER 1000

