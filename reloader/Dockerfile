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

FROM registry.access.redhat.com/ubi9-minimal@sha256:4b79c93106c14ad1c234907f83441ff0e4f8d24e78426a36e159098e9f7e6fa5
ARG RELOADER_VERSION
LABEL konflux.additional-tags=${RELOADER_VERSION}
WORKDIR /
COPY --from=builder /workspace/manager /manager
USER 65532:65532
EXPOSE 9090
ENTRYPOINT ["/manager"]
