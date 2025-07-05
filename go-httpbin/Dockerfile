FROM registry.access.redhat.com/ubi9/go-toolset@sha256:381fb72f087a07432520fa93364f66b5981557f1dd708f3c4692d6d0a76299b3 AS builder
ARG HTTPBIN_VERSION=v2.18.1
RUN go install github.com/mccutchen/go-httpbin/v2/cmd/go-httpbin@${HTTPBIN_VERSION}

FROM registry.access.redhat.com/ubi9/ubi-minimal:latest
WORKDIR /
COPY --from=builder /opt/app-root/src/go/bin/go-httpbin /usr/bin
ENTRYPOINT ["/usr/bin/go-httpbin"]