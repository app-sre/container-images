FROM registry.access.redhat.com/ubi8/go-toolset:1.24.4-1753663298@sha256:844dfc3af513533d9fc4c836bfd1c52455b4ed55d05c6ee942dc140f0903d0ae as builder
ENV GOPATH=/go/
ENV GO111MODULE=on
USER root
WORKDIR /go/src/github.com/prometheus-community/jiralert
RUN git clone \
    https://github.com/prometheus-community/jiralert.git .
RUN git checkout d43cbab62126d543e8e789f6374d9e745693cce2
# run just build and skip all other steps because the linter needs to much memory
RUN make build

FROM registry.access.redhat.com/ubi8-minimal:8.10-1753978370@sha256:af9b4a20cf942aa5bce236fedfefde887a7d89eb7c69f727bd0af9f5c80504ab
LABEL konflux.additional-tags=1.0.0
RUN microdnf update -y \
    && rm -rf /var/cache/yum \
    && microdnf install ca-certificates
WORKDIR /
COPY --from=builder /go/src/github.com/prometheus-community/jiralert/jiralert /usr/bin
ENTRYPOINT ["/usr/bin/jiralert"]
