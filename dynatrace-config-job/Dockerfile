FROM registry.access.redhat.com/ubi9-minimal@sha256:d235f607e1d6d833f031db107dc42206e4dd4d5aa9142c43d3771fb7f9bea76a

# https://konflux.pages.redhat.com/docs/users/how-tos/configuring/custom-tags.html
# Set your image version here
LABEL konflux.additional-tags="2.12"

COPY LICENSE /licenses/LICENSE

RUN microdnf install jq-1.6 -y &&\
    microdnf clean all 

USER ${USER}

