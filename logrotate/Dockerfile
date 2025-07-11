FROM registry.access.redhat.com/ubi9/ubi-minimal:9.6-1752069876@sha256:11db23b63f9476e721f8d0b8a2de5c858571f76d5a0dae2ec28adf08cbaf3652

# Install logrotate
RUN microdnf update && \
    microdnf install -y logrotate && \
    microdnf clean all

RUN mkdir -p /etc/logrotate.d

# Default command to run logrotate
# Meant to be overridden by the user
CMD ["logrotate", "/etc/logrotate.d/log_to_rotate"]
