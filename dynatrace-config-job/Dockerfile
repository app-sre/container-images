FROM registry.access.redhat.com/ubi9-minimal@sha256:7fbeae18dc9476399f565e68255f602a3374ea8614ba3d14843565131a13ff93

# https://konflux.pages.redhat.com/docs/users/how-tos/configuring/custom-tags.html
# Set your image version here
LABEL konflux.additional-tags="2.12"

COPY LICENSE /licenses/LICENSE

RUN microdnf install jq-1.6 -y &&\
    microdnf clean all 

USER ${USER}

