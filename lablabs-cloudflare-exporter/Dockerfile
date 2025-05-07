FROM registry.access.redhat.com/ubi8/go-toolset:1.23.6-2@sha256:3b55bd3a4aec7f72e088af4d2a507b1f9c81b573d180ddb580d051cb544bf1a4 as builder
ENV GOPATH=/go/
ENV GO111MODULE=on
USER root
WORKDIR /go/src/github.com/app-sre/cloudflare-exporter
RUN git clone \
    -b 0.0.14-fork-lp-metrics \
    https://github.com/app-sre/cloudflare-exporter.git .
# RUN go get -d -v
RUN CGO_ENABLED=0 GOOS=linux go build -o cloudflare_exporter .

FROM registry.access.redhat.com/ubi8-minimal:8.10-1255@sha256:b2a1bec3dfbc7a14a1d84d98934dfe8fdde6eb822a211286601cf109cbccb075
RUN microdnf update -y \
    && rm -rf /var/cache/yum \
    && microdnf install ca-certificates
WORKDIR /
COPY --from=builder /go/src/github.com/app-sre/cloudflare-exporter/cloudflare_exporter /usr/bin
ENTRYPOINT ["/usr/bin/cloudflare_exporter"]
