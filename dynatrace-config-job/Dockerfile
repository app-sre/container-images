FROM registry.access.redhat.com/ubi9-minimal@sha256:0d7cfb0704f6d389942150a01a20cb182dc8ca872004ebf19010e2b622818926

# https://konflux.pages.redhat.com/docs/users/how-tos/configuring/custom-tags.html
# Set your image version here
LABEL konflux.additional-tags="2.12"

COPY LICENSE /licenses/LICENSE

RUN microdnf install jq-1.6 -y &&\
    microdnf clean all 

USER ${USER}

