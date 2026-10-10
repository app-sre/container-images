FROM registry.access.redhat.com/ubi9/ubi-minimal:9.8-1791279563@sha256:5ed244b62bbf4095080144d9d35eb8fcd3d39a9801f94aadd63b9d10978a01ae
LABEL konflux.additional-tags=1.0.3

# Install logrotate
RUN microdnf update -y && \
    microdnf install -y logrotate && \
    microdnf clean all

RUN mkdir -p /etc/logrotate.d

# Default command to run logrotate
# Meant to be overridden by the user
CMD ["logrotate", "/etc/logrotate.d/log_to_rotate"]
