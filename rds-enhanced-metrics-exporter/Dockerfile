FROM registry.access.redhat.com/ubi8/go-toolset:latest@sha256:4842bf7e31849a442f4c6d00f00fe3a6d4793525764e0ddb3ba098c6649a7f67 as builder
ENV COMMIT=8de8628
WORKDIR rds_exporter
RUN git clone --depth 1 https://github.com/percona/rds_exporter.git . && \
    git checkout $COMMIT
RUN make release

FROM registry.access.redhat.com/ubi8-minimal:8.2@sha256:5cfbaf45ca96806917830c183e9f37df2e913b187aadb32e89fd83fa455ebaa6
COPY --from=builder /opt/app-root/src/rds_exporter/rds_exporter .
ENTRYPOINT ["/rds_exporter", "--config.file=/rds-exporter-config/config.yml"]
