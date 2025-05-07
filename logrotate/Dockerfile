FROM registry.access.redhat.com/ubi9/ubi-minimal:9.5-1745855087@sha256:e1c4703364c5cb58f5462575dc90345bcd934ddc45e6c32f9c162f2b5617681c

# Install logrotate
RUN microdnf update && \
    microdnf install -y logrotate && \
    microdnf clean all

RUN mkdir -p /etc/logrotate.d

# Default command to run logrotate
# Meant to be overridden by the user
CMD ["logrotate", "/etc/logrotate.d/log_to_rotate"]
