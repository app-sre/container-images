# Konflux rebuild trigger (APPSRE-14854/APPSRE-14895): no functional change.
FROM registry.access.redhat.com/ubi9/go-toolset@sha256:60fd6fb2998c40ad0d6561c34e83588b986a0cf7771f64e5e5c295ba87101f9b as builder
ENV COMMIT=8de8628580736b9ac74ad084b1844a75fbef8933
WORKDIR rds_exporter
RUN git init && \
    git remote add origin https://github.com/percona/rds_exporter.git && \
    git fetch --depth 1 origin $COMMIT && \
    git checkout $COMMIT
RUN make release

FROM registry.access.redhat.com/ubi9-minimal@sha256:c4c285d42941ebb2bd4da878479008e1e4536bb599aad1dbe568f89de9053661
COPY --from=builder /opt/app-root/src/rds_exporter/rds_exporter .
ENTRYPOINT ["/rds_exporter", "--config.file=/rds-exporter-config/config.yml"]
