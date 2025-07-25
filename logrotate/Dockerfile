FROM registry.access.redhat.com/ubi9/ubi-minimal:9.4@sha256:c0e70387664f30cd9cf2795b547e4a9a51002c44a4a86aa9335ab030134bf392
LABEL konflux.additional-tags=1.0.0

# Install logrotate
RUN microdnf update -y && \
    microdnf install -y logrotate && \
    microdnf clean all

RUN mkdir -p /etc/logrotate.d

# Default command to run logrotate
# Meant to be overridden by the user
CMD ["logrotate", "/etc/logrotate.d/log_to_rotate"]
