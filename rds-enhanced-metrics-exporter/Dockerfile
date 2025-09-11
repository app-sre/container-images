FROM registry.access.redhat.com/ubi9/go-toolset@sha256:14c369670cf3473d8e9b93e42d120c01b79a6f13884c396a1c89b7ca46f859b7 as builder
ENV COMMIT=8de8628
WORKDIR rds_exporter
RUN git clone --depth 1 https://github.com/percona/rds_exporter.git . && \
    git checkout $COMMIT
RUN make release

FROM registry.access.redhat.com/ubi9-minimal@sha256:2f06ae0e6d3d9c4f610d32c480338eef474867f435d8d28625f2985e8acde6e8
COPY --from=builder /opt/app-root/src/rds_exporter/rds_exporter .
ENTRYPOINT ["/rds_exporter", "--config.file=/rds-exporter-config/config.yml"]
