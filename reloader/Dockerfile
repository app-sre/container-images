# Konflux rebuild trigger (APPSRE-14854/APPSRE-14895): no functional change.
ARG RELOADER_VERSION=v1.4.14

FROM registry.access.redhat.com/ubi9/go-toolset:9.9-1794518352@sha256:4053e919374d739ee6b0007e412d89256b0bd065e0bc690c2b3905bbaab6500e as builder
ARG RELOADER_VERSION
ENV GO111MODULE=on
ENV GOTOOLCHAIN=go1.26.1
WORKDIR /workspace
RUN git clone --branch ${RELOADER_VERSION} --depth 1 \
    https://github.com/stakater/Reloader.git .
RUN CGO_ENABLED=0 \
    GOOS=${TARGETOS:-linux} \
    GOARCH=${TARGETARCH} \
    GO111MODULE=on \
    go build -ldflags="-s -w \
        -X github.com/stakater/Reloader/pkg/common.Version=${RELOADER_VERSION} \
        -X github.com/stakater/Reloader/pkg/common.Edition=oss" \
      -installsuffix 'static' -mod=mod -a -o manager ./

FROM registry.access.redhat.com/ubi9-minimal@sha256:f26ef64172ea61f5ac5ba4be8c5c738bf8760b22b3e5148ce7b40f7308ab32db
ARG RELOADER_VERSION
LABEL konflux.additional-tags=${RELOADER_VERSION}
WORKDIR /
COPY --from=builder /workspace/manager /manager
USER 65532:65532
EXPOSE 9090
ENTRYPOINT ["/manager"]
