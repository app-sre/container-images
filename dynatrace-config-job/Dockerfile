FROM registry.access.redhat.com/ubi9/ubi-minimal:9.2

# https://konflux.pages.redhat.com/docs/users/how-tos/configuring/custom-tags.html
# Set your image version here
LABEL konflux.additional-tags="2.7"

RUN microdnf install jq-1.6 -y &&\
    microdnf clean all 

