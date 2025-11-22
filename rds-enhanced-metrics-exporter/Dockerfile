FROM registry.access.redhat.com/ubi9/go-toolset@sha256:71f121a44270e46a17a548d6b92096a1a0fb56db44927ad318d095177d6dce4b as builder
ENV COMMIT=8de8628
WORKDIR rds_exporter
RUN git clone --depth 1 https://github.com/percona/rds_exporter.git . && \
    git checkout $COMMIT
RUN make release

FROM registry.access.redhat.com/ubi9-minimal@sha256:61d5ad475048c2e655cd46d0a55dfeaec182cc3faa6348cb85989a7c9e196483
COPY --from=builder /opt/app-root/src/rds_exporter/rds_exporter .
ENTRYPOINT ["/rds_exporter", "--config.file=/rds-exporter-config/config.yml"]
