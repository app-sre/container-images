FROM registry.access.redhat.com/ubi9/go-toolset@sha256:380d6de9bbc5a42ca13d425be99958fb397317664bb8a00e49d464e62cc8566c as builder
ENV COMMIT=8de8628
WORKDIR rds_exporter
RUN git clone --depth 1 https://github.com/percona/rds_exporter.git . && \
    git checkout $COMMIT
RUN make release

FROM registry.access.redhat.com/ubi9-minimal@sha256:53ea1f6d835898acda5becdb3f8b1292038a480384bbcf994fc0bcf1f7e8eaf7
COPY --from=builder /opt/app-root/src/rds_exporter/rds_exporter .
ENTRYPOINT ["/rds_exporter", "--config.file=/rds-exporter-config/config.yml"]
