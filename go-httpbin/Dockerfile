ARG HTTPBIN_VERSION="2.18.1"

FROM registry.access.redhat.com/ubi9/go-toolset@sha256:7b1828de52c3bac600a71b81996bf748776a456181a45e2b329b39702cf6486f AS builder
ARG HTTPBIN_VERSION
RUN go install github.com/mccutchen/go-httpbin/v2/cmd/go-httpbin@v${HTTPBIN_VERSION}

FROM registry.access.redhat.com/ubi9-minimal@sha256:34880b64c07f28f64d95737f82f891516de9a3b43583f39970f7bf8e4cfa48b7
ARG HTTPBIN_VERSION
LABEL konflux.additional-tags=${HTTPBIN_VERSION}

COPY LICENSE /licenses/LICENSE
WORKDIR /
COPY --from=builder /opt/app-root/src/go/bin/go-httpbin /usr/bin
ENTRYPOINT ["/usr/bin/go-httpbin"]
