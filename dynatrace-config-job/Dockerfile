FROM registry.access.redhat.com/ubi9-minimal@sha256:c4c285d42941ebb2bd4da878479008e1e4536bb599aad1dbe568f89de9053661

# https://konflux.pages.redhat.com/docs/users/how-tos/configuring/custom-tags.html
# Set your image version here
LABEL konflux.additional-tags="2.13"

COPY LICENSE /licenses/LICENSE

RUN microdnf install jq-1.6 -y &&\
    microdnf clean all 

USER ${USER}

