FROM registry.access.redhat.com/ubi9/ubi-minimal:9.8-1789546276@sha256:7b8e25a1b56ca4d00219198f3b5b51a3e1693a5c4f5369c5e190d7d6cb3f980e
LABEL konflux.additional-tags=1.0.3

# Install logrotate
RUN microdnf update -y && \
    microdnf install -y logrotate && \
    microdnf clean all

RUN mkdir -p /etc/logrotate.d

# Default command to run logrotate
# Meant to be overridden by the user
CMD ["logrotate", "/etc/logrotate.d/log_to_rotate"]
