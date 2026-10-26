# Konflux rebuild trigger (APPSRE-14854/APPSRE-14895): no functional change.
FROM registry.access.redhat.com/ubi9/go-toolset@sha256:c51f0f31cbaa7e91dede6013f636d54fe10dd7d581cfc4cda014ba9d62bcd779 as builder
ENV COMMIT=8de8628580736b9ac74ad084b1844a75fbef8933
WORKDIR rds_exporter
RUN git init && \
    git remote add origin https://github.com/percona/rds_exporter.git && \
    git fetch --depth 1 origin $COMMIT && \
    git checkout $COMMIT
RUN make release

FROM registry.access.redhat.com/ubi9-minimal@sha256:2d4c4551af6831dcd26bbf86108c4385de5183ec8fe6b5868f6f9640fe47f4ed
COPY --from=builder /opt/app-root/src/rds_exporter/rds_exporter .
ENTRYPOINT ["/rds_exporter", "--config.file=/rds-exporter-config/config.yml"]
