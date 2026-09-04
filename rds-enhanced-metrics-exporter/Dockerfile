FROM registry.access.redhat.com/ubi9/go-toolset@sha256:5e68f09a652ac6627a83c57655e42e24575efb278b54336039c9308607fc6b21 as builder
ENV COMMIT=8de8628580736b9ac74ad084b1844a75fbef8933
WORKDIR rds_exporter
RUN git init && \
    git remote add origin https://github.com/percona/rds_exporter.git && \
    git fetch --depth 1 origin $COMMIT && \
    git checkout $COMMIT
RUN make release

FROM registry.access.redhat.com/ubi9-minimal@sha256:7fbeae18dc9476399f565e68255f602a3374ea8614ba3d14843565131a13ff93
COPY --from=builder /opt/app-root/src/rds_exporter/rds_exporter .
ENTRYPOINT ["/rds_exporter", "--config.file=/rds-exporter-config/config.yml"]
