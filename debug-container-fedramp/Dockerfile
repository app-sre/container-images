
# Build a FedRamp-centric (appsre-ft3) container for debugging issues 
FROM quay.io/app-sre/ubi9-ubi-minimal@sha256:94b434a29a894129301f6ff52dbddb19422fc800a109170c634b056da8cd704f
COPY --from=ghcr.io/astral-sh/uv:0.6.14@sha256:3362a526af7eca2fcd8604e6a07e873fb6e4286d8837cb753503558ce1213664 /uv /bin/uv


# install uv (see: https://docs.astral.sh/uv/guides/integration/docker/#using-uv-in-docker)
ENV \
    UV_SYSTEM_PYTHON=1 \
    UV_NO_CACHE=true 


# dnf required for greater package index and security advisories
RUN microdnf install -y dnf 

#force a refresh of dnf but only auto-apply security upgrades
RUN dnf -y --refresh --security upgrade && \
    dnf -y install \
        alternatives \
        bind-utils \
        dnf-utils \
        dracut \
        git \
        iputils \
        mtr \
        net-tools \
        nmap \
        openssl \
        postgresql \
        procps-ng \
        python3-pip \
        rsync \
        skopeo \
        strace \
        tar \
    && dnf clean all

#requires dnf-utils to be present
RUN dnf config-manager --set-enabled ubi-9-baseos-rpms ubi-9-codeready-builder-rpms ubi-9-appstream-rpms    

# Install FedRamp specific version number (see AppSRE-FT3)
ENV OCP_VERSION=4.14.45
ENV OCP_URL=https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OCP_VERSION}/openshift-client-linux-${OCP_VERSION}.tar.gz
RUN curl -LO ${OCP_URL} && \
    tar -xvzf openshift-client-linux-${OCP_VERSION}.tar.gz && \
    mv oc kubectl /usr/local/bin/ && \
    chmod +x /usr/local/bin/oc /usr/local/bin/kubectl && \
    rm -f 



# anything normally installed via pip would go here (see: https://docs.astral.sh/uv/guides/integration/docker/#using-the-pip-interface)
RUN uv pip install --system awscli redis psycopg PyMySQL

# add repos to install multiple versions of psql
RUN dnf -y config-manager --add-repo https://download.postgresql.org/pub/repos/yum/13/redhat/rhel-9.2-x86_64 \
 && dnf -y config-manager --add-repo https://download.postgresql.org/pub/repos/yum/14/redhat/rhel-9.2-x86_64 \
 && dnf -y config-manager --add-repo https://download.postgresql.org/pub/repos/yum/15/redhat/rhel-9.2-x86_64 \
 && dnf -y config-manager --add-repo https://download.postgresql.org/pub/repos/yum/16/redhat/rhel-9.2-x86_64 \
 && dnf update -y 

 
# install multiple versions of psql
RUN dnf -y --nogpgcheck install postgresql13 \ 
                                postgresql14 \
                                postgresql15 \
                                postgresql16 \
                             && dnf clean all \
                             && rm -rf /var/cache/dnf

RUN export PGSSLCIPHERS='TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256:TLS_AES_128_GCM_SHA256:scram-sha-256'
RUN export OPENSSL_FIPS=1


# FedRamp requires the ability to connect to multiple versions of Postgresql
# the alternatives program allows a seamless switching between them
RUN alternatives --install /usr/bin/psql psql /usr/pgsql-13/bin/psql 130 && \
    alternatives --install /usr/bin/psql psql /usr/pgsql-14/bin/psql 140 && \
    alternatives --install /usr/bin/psql psql /usr/pgsql-15/bin/psql 150 && \
    alternatives --install /usr/bin/psql psql /usr/pgsql-16/bin/psql 160 && \
    alternatives --install /usr/bin/psql psql /usr/pgsql-17/bin/psql 170 

RUN chmod -R 775 /var/lib/alternatives/ 
RUN chmod -R 775 /etc/alternatives/ 

ENV PS1="\[\e[31m\]\[\e[0m\]\ndebug-fedramp\[\e[0;32m\]\u\[\e[m\]@\[\e[0;33m\]\h\[\e[m\]:\[\e[0;34m\]\w\[\e[m\] \$ "

USER 0

