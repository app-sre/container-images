FROM registry.access.redhat.com/ubi9/go-toolset@sha256:e0ad156b08e0b50ad509d79513e13e8a31f2812c66e9c48c98cea53420ec2bca AS builder
ARG HTTPBIN_VERSION=v2.18.1
RUN go install github.com/mccutchen/go-httpbin/v2/cmd/go-httpbin@${HTTPBIN_VERSION}

FROM registry.access.redhat.com/ubi9/ubi-minimal:latest
WORKDIR /
COPY --from=builder /opt/app-root/src/go/bin/go-httpbin /usr/bin
ENTRYPOINT ["/usr/bin/go-httpbin"]