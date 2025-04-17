FROM registry.access.redhat.com/ubi8/go-toolset:1.23.6-1.1744600118@sha256:292c09f5962fed4ea5c239c6901cd14f21d97efbec55788637212bc5ada01707 as builder
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
