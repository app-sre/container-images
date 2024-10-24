FROM registry.access.redhat.com/ubi9/ubi-minimal:9.2@sha256:c8c7a06ce1c5fa23c1cbd7a0fd891eacd099bc232aa9985ddb183cfe98d1deaf

# https://konflux.pages.redhat.com/docs/users/how-tos/configuring/custom-tags.html
# Set your image version here
LABEL konflux.additional-tags="2.9"

RUN microdnf install jq-1.6 -y &&\
    microdnf clean all 

