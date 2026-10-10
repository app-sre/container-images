FROM registry.access.redhat.com/ubi8/go-toolset:1.26.7-1791463800@sha256:4e3be91a3b5b9c0ffd45dd0a34c2ea26d92152900c2e44ae6b0b6498f2574c71 as builder
ENV GOPATH=/go/
ENV GO111MODULE=on
USER root
WORKDIR /go/src/github.com/prometheus-community/jiralert
RUN git clone \
    https://github.com/prometheus-community/jiralert.git .
RUN git checkout d43cbab62126d543e8e789f6374d9e745693cce2
# run just build and skip all other steps because the linter needs to much memory
RUN make build

FROM registry.access.redhat.com/ubi8-minimal:8.10-1791442285@sha256:99ae5911c373b1c9e15067646309e2212b6fe97b18cd39feb55f2f0b9be0f075
LABEL konflux.additional-tags=1.0.1
RUN microdnf update -y \
    && rm -rf /var/cache/yum \
    && microdnf install ca-certificates
WORKDIR /
COPY --from=builder /go/src/github.com/prometheus-community/jiralert/jiralert /usr/bin
ENTRYPOINT ["/usr/bin/jiralert"]
