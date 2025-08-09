FROM registry.access.redhat.com/ubi8/go-toolset:1.24.4-1754557074@sha256:45c232cb9eb2400b8c7a9906daee381b057a55ee60b6a59b7035b471b4d919f4 as builder
ENV GOPATH=/go/
ENV GO111MODULE=on
USER root
WORKDIR /go/src/github.com/app-sre/cloudflare-exporter
RUN git clone \
    -b 0.0.14-fork-lp-metrics \
    https://github.com/app-sre/cloudflare-exporter.git .
# RUN go get -d -v
RUN CGO_ENABLED=0 GOOS=linux go build -o cloudflare_exporter .

FROM registry.access.redhat.com/ubi8-minimal:8.10-1754402686@sha256:319057f561604173dc6a4c3648295159d34b1c7996f526a1e0c2352309dbb2dd
RUN microdnf update -y \
    && rm -rf /var/cache/yum \
    && microdnf install ca-certificates
WORKDIR /
COPY --from=builder /go/src/github.com/app-sre/cloudflare-exporter/cloudflare_exporter /usr/bin
ENTRYPOINT ["/usr/bin/cloudflare_exporter"]
