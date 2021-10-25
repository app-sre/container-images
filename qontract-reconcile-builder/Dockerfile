FROM registry.access.redhat.com/ubi8/ubi:8.4

WORKDIR /work

RUN dnf install -y \
        python39 \
        gnupg2 \
        python3{,9}-devel \
        make \
        gcc \
        gcc-c++ \
        openssl \
        glibc-langpack-en \
        git && \
    dnf clean all && \
    update-alternatives --set python3 /usr/bin/python3.9
