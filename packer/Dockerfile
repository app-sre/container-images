FROM registry.access.redhat.com/ubi8/ubi-minimal:latest@sha256:5b195cf0b8eb2262ce81334ee44066fdb5026022803f55bfe607be7d08d4fe43

RUN curl --location --output /etc/yum.repos.d/hashicorp.repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
RUN microdnf install packer jq openssh-clients unzip rsync python3 rust cargo gcc python3-devel openssl-devel
RUN pip3 install setuptools-rust
RUN pip3 install ansible
RUN ansible-galaxy collection install ansible.posix
RUN curl https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip -o /tmp/awscli.zip
RUN unzip /tmp/awscli.zip
RUN aws/install
