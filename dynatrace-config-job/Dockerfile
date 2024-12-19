FROM registry.access.redhat.com/ubi9/ubi-minimal:9.5-1731593028@sha256:d85040b6e3ed3628a89683f51a38c709185efc3fb552db2ad1b9180f2a6c38be

# https://konflux.pages.redhat.com/docs/users/how-tos/configuring/custom-tags.html
# Set your image version here
LABEL konflux.additional-tags="2.11"

COPY LICENSE /licenses/LICENSE

RUN microdnf install jq-1.6 -y &&\
    microdnf clean all 

USER ${USER}

