FROM registry.access.redhat.com/ubi8/go-toolset:1.26.5-1787215294@sha256:6e1aff6035d68a465ae3b5f0d5e155dbf7f2c965b03aa9c9e4bfb3f5e1d7a34a as builder
ENV GOPATH=/go/
ENV GO111MODULE=on
USER root
WORKDIR /go/src/github.com/app-sre/cloudflare-exporter
RUN git clone \
    -b 0.0.14-fork-lp-metrics \
    https://github.com/app-sre/cloudflare-exporter.git .
# RUN go get -d -v
RUN CGO_ENABLED=0 GOOS=linux go build -o cloudflare_exporter .

FROM registry.access.redhat.com/ubi8-minimal:8.10-1787081751@sha256:8eb4bce220776c3ce885d9ee48430094c9bce2943de30fcdc1e080acde6948f9
RUN microdnf update -y \
    && rm -rf /var/cache/yum \
    && microdnf install ca-certificates
WORKDIR /
COPY --from=builder /go/src/github.com/app-sre/cloudflare-exporter/cloudflare_exporter /usr/bin
ENTRYPOINT ["/usr/bin/cloudflare_exporter"]
