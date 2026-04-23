ARG RELOADER_VERSION=v1.4.14

FROM registry.access.redhat.com/ubi9/go-toolset:1.25.8@sha256:77bfb0f283eaa3215909342c3dda940605eff5b9f72d6dc18fad1d154d172d55 as builder
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

FROM registry.access.redhat.com/ubi9-minimal@sha256:fe688da81a696387ca53a4c19231e99289591f990c904ef913c51b6e87d4e4df
ARG RELOADER_VERSION
LABEL konflux.additional-tags=${RELOADER_VERSION}
WORKDIR /
COPY --from=builder /workspace/manager /manager
USER 65532:65532
EXPOSE 9090
ENTRYPOINT ["/manager"]
