FROM registry.access.redhat.com/ubi8/go-toolset:1.22.9-3.1742991062@sha256:825c51a21564019c8859645612c4c085f7b7dc485957729d9245cdc06a24cf1e as builder
ENV GOPATH=/go/
ENV GO111MODULE=on
USER root
WORKDIR /go/src/github.com/app-sre/cloudflare-exporter
RUN git clone \
    -b 0.0.14-fork-lp-metrics \
    https://github.com/app-sre/cloudflare-exporter.git .
# RUN go get -d -v
RUN CGO_ENABLED=0 GOOS=linux go build -o cloudflare_exporter .

FROM registry.access.redhat.com/ubi8-minimal:8.10-1216@sha256:3544399c893a7f32d16220d22d493ae32e61379668e32bc54a74d8eb6ece80fc
RUN microdnf update -y \
    && rm -rf /var/cache/yum \
    && microdnf install ca-certificates
WORKDIR /
COPY --from=builder /go/src/github.com/app-sre/cloudflare-exporter/cloudflare_exporter /usr/bin
ENTRYPOINT ["/usr/bin/cloudflare_exporter"]
