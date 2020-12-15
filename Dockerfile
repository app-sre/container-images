FROM registry.access.redhat.com/ubi8/ubi:8.2

ENV LC_ALL=en_US.utf8
ENV LANG=en_US.utf8

RUN dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable.repo https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/CentOS_8/devel:kubic:libcontainers:stable.repo && \
    dnf install -y skopeo python3 python3-pip python3-devel git make tar gzip unzip gcc gcc-c++ openssh-clients openssl glibc-langpack-en && \
    python3 -m pip install --upgrade pip setuptools && \
    dnf clean all
