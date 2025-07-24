ARG HTTPBIN_VERSION="2.18.1"

FROM registry.access.redhat.com/ubi9/go-toolset@sha256:e0ad156b08e0b50ad509d79513e13e8a31f2812c66e9c48c98cea53420ec2bca AS builder
ARG HTTPBIN_VERSION
RUN go install github.com/mccutchen/go-httpbin/v2/cmd/go-httpbin@v${HTTPBIN_VERSION}

FROM registry.access.redhat.com/ubi9-minimal@sha256:92b1d5747a93608b6adb64dfd54515c3c5a360802db4706765ff3d8470df6290
ARG HTTPBIN_VERSION
LABEL konflux.additional-tags=${HTTPBIN_VERSION}

COPY LICENSE /licenses/LICENSE
WORKDIR /
COPY --from=builder /opt/app-root/src/go/bin/go-httpbin /usr/bin
ENTRYPOINT ["/usr/bin/go-httpbin"]
