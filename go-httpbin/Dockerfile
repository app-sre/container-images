ARG HTTPBIN_VERSION="2.18.1"

FROM registry.access.redhat.com/ubi9/go-toolset@sha256:3ce6311380d5180599a3016031a9112542d43715244816d1d0eabc937952667b AS builder
ARG HTTPBIN_VERSION
RUN go install github.com/mccutchen/go-httpbin/v2/cmd/go-httpbin@v${HTTPBIN_VERSION}

FROM registry.access.redhat.com/ubi9-minimal@sha256:0d7cfb0704f6d389942150a01a20cb182dc8ca872004ebf19010e2b622818926
ARG HTTPBIN_VERSION
LABEL konflux.additional-tags=${HTTPBIN_VERSION}

COPY LICENSE /licenses/LICENSE
WORKDIR /
COPY --from=builder /opt/app-root/src/go/bin/go-httpbin /usr/bin
ENTRYPOINT ["/usr/bin/go-httpbin"]
