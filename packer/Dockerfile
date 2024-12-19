FROM registry.access.redhat.com/ubi8/ubi-minimal:latest@sha256:cf095e5668919ba1b4ace3888107684ad9d587b1830d3eb56973e6a54f456e67

RUN curl --location --output /etc/yum.repos.d/hashicorp.repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
RUN microdnf install packer jq openssh-clients unzip rsync python3 rust cargo gcc python3-devel openssl-devel
RUN pip3 install setuptools-rust
RUN pip3 install ansible
RUN ansible-galaxy collection install ansible.posix
RUN curl https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip -o /tmp/awscli.zip
RUN unzip /tmp/awscli.zip
RUN aws/install
