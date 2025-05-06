FROM registry.access.redhat.com/ubi8/ubi-minimal:latest@sha256:b2a1bec3dfbc7a14a1d84d98934dfe8fdde6eb822a211286601cf109cbccb075

RUN curl --location --output /etc/yum.repos.d/hashicorp.repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
RUN microdnf install packer jq openssh-clients unzip rsync python3 rust cargo gcc python3-devel openssl-devel
RUN pip3 install setuptools-rust
RUN pip3 install ansible
RUN ansible-galaxy collection install ansible.posix
RUN curl https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip -o /tmp/awscli.zip
RUN unzip /tmp/awscli.zip
RUN aws/install
