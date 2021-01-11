FROM registry.access.redhat.com/ubi8/ubi:8.2

ENV LC_ALL=en_US.utf8
ENV LANG=en_US.utf8

RUN dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable.repo https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/CentOS_8/devel:kubic:libcontainers:stable.repo && \
    dnf install -y python3 python3-pip python3-devel git make tar gzip unzip gcc gcc-c++ openssh-clients openssl glibc-langpack-en && \
    CONT_COMMON_PKG=$(dnf list -q containers-common.x86_64 | tail -1 | awk '{print $1"-"$2}' | sed 's/\(.*\).x86_64-[0-9]:\(.*\)\(.el8\)$/\1-\2\3.x86_64.rpm/') && \
    rpm -vi https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/CentOS_8/x86_64/${CONT_COMMON_PKG} && \
    SKOPEO_PKG=$(dnf list -q skopeo.x86_64 | tail -1 | awk '{print $1"-"$2}' | sed 's/\(.*\).x86_64-[0-9]:\(.*\)\(.el8\)$/\1-\2\3.x86_64.rpm/') && \
    rpm -vi https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/CentOS_8/x86_64/${SKOPEO_PKG} && \
    python3 -m pip install --upgrade pip setuptools && \
    dnf clean all
