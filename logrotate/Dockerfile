FROM registry.access.redhat.com/ubi9/ubi-minimal:9.6-1754584681@sha256:8d905a93f1392d4a8f7fb906bd49bf540290674b28d82de3536bb4d0898bf9d7
LABEL konflux.additional-tags=1.0.1

# Install logrotate
RUN microdnf update -y && \
    microdnf install -y logrotate && \
    microdnf clean all

RUN mkdir -p /etc/logrotate.d

# Default command to run logrotate
# Meant to be overridden by the user
CMD ["logrotate", "/etc/logrotate.d/log_to_rotate"]
