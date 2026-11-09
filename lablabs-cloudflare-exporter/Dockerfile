FROM registry.access.redhat.com/ubi8/go-toolset:1.26.10-1793808960@sha256:1a0bd73ea52b93dffbd0175726a9cdcfa3f83ce374e9bee455303ecfd12897ba as builder
ENV GOPATH=/go/
ENV GO111MODULE=on
USER root
WORKDIR /go/src/github.com/app-sre/cloudflare-exporter
RUN git clone \
    -b 0.0.14-fork-lp-metrics \
    https://github.com/app-sre/cloudflare-exporter.git .
# RUN go get -d -v
RUN CGO_ENABLED=0 GOOS=linux go build -o cloudflare_exporter .

FROM registry.access.redhat.com/ubi8-minimal:8.10-1793860563@sha256:7c5f7ae1bcad8d2ebbc364bb8f62c76f50e5666062a65a5cc969d9d1e54ce0d8
RUN microdnf update -y \
    && rm -rf /var/cache/yum \
    && microdnf install ca-certificates
WORKDIR /
COPY --from=builder /go/src/github.com/app-sre/cloudflare-exporter/cloudflare_exporter /usr/bin
ENTRYPOINT ["/usr/bin/cloudflare_exporter"]
