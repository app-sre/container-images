ARG HTTPBIN_VERSION="2.18.1"

FROM registry.access.redhat.com/ubi9/go-toolset@sha256:a90b4605b47c396c74de55f574d0f9e03b24ca177dec54782f86cdf702c97dbc AS builder
ARG HTTPBIN_VERSION
RUN go install github.com/mccutchen/go-httpbin/v2/cmd/go-httpbin@v${HTTPBIN_VERSION}

FROM registry.access.redhat.com/ubi9-minimal@sha256:6d5a6576c83816edcc0da7ed62ba69df8f6ad3cbe659adde2891bfbec4dbf187
ARG HTTPBIN_VERSION
LABEL konflux.additional-tags=${HTTPBIN_VERSION}

COPY LICENSE /licenses/LICENSE
WORKDIR /
COPY --from=builder /opt/app-root/src/go/bin/go-httpbin /usr/bin
ENTRYPOINT ["/usr/bin/go-httpbin"]
