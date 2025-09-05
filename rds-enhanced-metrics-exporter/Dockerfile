FROM registry.access.redhat.com/ubi8/go-toolset:latest@sha256:4842bf7e31849a442f4c6d00f00fe3a6d4793525764e0ddb3ba098c6649a7f67 as builder
ENV GOPATH=/go/
USER root
RUN mkdir -p /go/src/github.com/percona/rds_exporter
WORKDIR /go/src/github.com/percona/rds_exporter
RUN git clone --progress --verbose https://github.com/percona/rds_exporter.git .
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o rds_exporter .

FROM registry.access.redhat.com/ubi8-minimal:8.2@sha256:5cfbaf45ca96806917830c183e9f37df2e913b187aadb32e89fd83fa455ebaa6
RUN microdnf update -y && rm -rf /var/cache/yum && microdnf install ca-certificates
WORKDIR /
COPY --from=builder /go/src/github.com/percona/rds_exporter/rds_exporter .
ENTRYPOINT ["./rds_exporter", "--config.file=/rds-exporter-config/config.yml"]
