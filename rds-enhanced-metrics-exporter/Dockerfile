FROM registry.access.redhat.com/ubi9/go-toolset@sha256:359dd4c6c4255b3f7bce4dc15ffa5a9aa65a401f819048466fa91baa8244a793 as builder
ENV COMMIT=8de8628
WORKDIR rds_exporter
RUN git clone --depth 1 https://github.com/percona/rds_exporter.git . && \
    git checkout $COMMIT
RUN make release

FROM registry.access.redhat.com/ubi9-minimal@sha256:bb08f2300cb8d12a7eb91dddf28ea63692b3ec99e7f0fa71a1b300f2756ea829
COPY --from=builder /opt/app-root/src/rds_exporter/rds_exporter .
ENTRYPOINT ["/rds_exporter", "--config.file=/rds-exporter-config/config.yml"]
