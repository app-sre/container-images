FROM registry.access.redhat.com/ubi8/ubi-minimal:latest@sha256:c12e67af6a7e15113d76bc72f10bef2045c026c71ec8b7124c8a075458188a83

RUN curl --location --output /etc/yum.repos.d/hashicorp.repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
RUN microdnf install packer jq openssh-clients unzip rsync python3 rust cargo gcc python3-devel openssl-devel
RUN pip3 install setuptools-rust
RUN pip3 install ansible
RUN ansible-galaxy collection install ansible.posix
RUN curl https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip -o /tmp/awscli.zip
RUN unzip /tmp/awscli.zip
RUN aws/install
