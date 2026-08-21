FROM registry.access.redhat.com/ubi8/go-toolset:1.26.5-1787215294@sha256:6e1aff6035d68a465ae3b5f0d5e155dbf7f2c965b03aa9c9e4bfb3f5e1d7a34a as builder
ENV GOPATH=/go/
ENV GO111MODULE=on
USER root
WORKDIR /go/src/github.com/prometheus-community/jiralert
RUN git clone \
    https://github.com/prometheus-community/jiralert.git .
RUN git checkout d43cbab62126d543e8e789f6374d9e745693cce2
# run just build and skip all other steps because the linter needs to much memory
RUN make build

FROM registry.access.redhat.com/ubi8-minimal:8.10-1787081751@sha256:8eb4bce220776c3ce885d9ee48430094c9bce2943de30fcdc1e080acde6948f9
LABEL konflux.additional-tags=1.0.0
RUN microdnf update -y \
    && rm -rf /var/cache/yum \
    && microdnf install ca-certificates
WORKDIR /
COPY --from=builder /go/src/github.com/prometheus-community/jiralert/jiralert /usr/bin
ENTRYPOINT ["/usr/bin/jiralert"]
