FROM registry.access.redhat.com/ubi8/go-toolset:1.26.10-1794442109@sha256:0467f5aa1bc9e4ff74536ecab11dffdb6a19c2605a65d32a452d5ca7154072bd as builder
ENV GOPATH=/go/
ENV GO111MODULE=on
USER root
WORKDIR /go/src/github.com/app-sre/cloudflare-exporter
RUN git clone \
    -b 0.0.14-fork-lp-metrics \
    https://github.com/app-sre/cloudflare-exporter.git .
# RUN go get -d -v
RUN CGO_ENABLED=0 GOOS=linux go build -o cloudflare_exporter .

FROM registry.access.redhat.com/ubi8-minimal:8.10-1794442960@sha256:b3314c5f8d009ee6df04ead732bca6d3eaf011750185e348f55fce2678fb30d0
RUN microdnf update -y \
    && rm -rf /var/cache/yum \
    && microdnf install ca-certificates
WORKDIR /
COPY --from=builder /go/src/github.com/app-sre/cloudflare-exporter/cloudflare_exporter /usr/bin
ENTRYPOINT ["/usr/bin/cloudflare_exporter"]
