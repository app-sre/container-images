FROM registry.access.redhat.com/ubi9/ubi-minimal:9.5-1733767867@sha256:dee813b83663d420eb108983a1c94c614ff5d3fcb5159a7bd0324f0edbe7fca1

# https://konflux.pages.redhat.com/docs/users/how-tos/configuring/custom-tags.html
# Set your image version here
LABEL konflux.additional-tags="2.11"

COPY LICENSE /licenses/LICENSE

RUN microdnf install jq-1.6 -y &&\
    microdnf clean all 

USER ${USER}

