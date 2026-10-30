# Konflux rebuild trigger (APPSRE-14854/APPSRE-14895): no functional change.
ARG RELOADER_VERSION=v1.4.14

FROM registry.access.redhat.com/ubi9/go-toolset:9.8-1792010711@sha256:60fd6fb2998c40ad0d6561c34e83588b986a0cf7771f64e5e5c295ba87101f9b as builder
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

FROM registry.access.redhat.com/ubi9-minimal@sha256:bba2b4bbf0ed15cfe7dd72a1e17ae7d2015a141f306b304e1a2785c41400e39c
ARG RELOADER_VERSION
LABEL konflux.additional-tags=${RELOADER_VERSION}
WORKDIR /
COPY --from=builder /workspace/manager /manager
USER 65532:65532
EXPOSE 9090
ENTRYPOINT ["/manager"]
