FROM registry.access.redhat.com/ubi9/ubi-minimal:9.8-1788166357@sha256:7fbeae18dc9476399f565e68255f602a3374ea8614ba3d14843565131a13ff93
LABEL konflux.additional-tags=1.0.2

# Install logrotate
RUN microdnf update -y && \
    microdnf install -y logrotate && \
    microdnf clean all

RUN mkdir -p /etc/logrotate.d

# Default command to run logrotate
# Meant to be overridden by the user
CMD ["logrotate", "/etc/logrotate.d/log_to_rotate"]
