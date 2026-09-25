# Konflux rebuild trigger (APPSRE-14854/APPSRE-14895): no functional change.
FROM registry.access.redhat.com/ubi9/go-toolset@sha256:0a4666f7a4eb0644c97a73cba198eb268691b270d97831822689e7a2088f87be as builder
ENV COMMIT=8de8628580736b9ac74ad084b1844a75fbef8933
WORKDIR rds_exporter
RUN git init && \
    git remote add origin https://github.com/percona/rds_exporter.git && \
    git fetch --depth 1 origin $COMMIT && \
    git checkout $COMMIT
RUN make release

FROM registry.access.redhat.com/ubi9-minimal@sha256:8ebe2ad8fdf3cab3e5a53c1edc69194c98209cfadab24b884f4ad9ebcf7bbbfc
COPY --from=builder /opt/app-root/src/rds_exporter/rds_exporter .
ENTRYPOINT ["/rds_exporter", "--config.file=/rds-exporter-config/config.yml"]
