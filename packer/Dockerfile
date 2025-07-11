FROM registry.access.redhat.com/ubi8/ubi-minimal:latest@sha256:9746f7ac575b4427fc9635f8f575289870a8b30dabf77ee992ae4c2f1e121cce

RUN curl --location --output /etc/yum.repos.d/hashicorp.repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
RUN microdnf install packer jq openssh-clients unzip rsync python3 rust cargo gcc python3-devel openssl-devel
RUN pip3 install setuptools-rust
RUN pip3 install ansible
RUN ansible-galaxy collection install ansible.posix
RUN curl https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip -o /tmp/awscli.zip
RUN unzip /tmp/awscli.zip
RUN aws/install
