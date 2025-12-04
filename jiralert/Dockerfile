FROM registry.access.redhat.com/ubi8/go-toolset:1.24.6-1764274816@sha256:c0d55dbaa26d2f2de93f5d7be61d1d3d003e42ed6ba87480eb927da82541f124 as builder
ENV GOPATH=/go/
ENV GO111MODULE=on
USER root
WORKDIR /go/src/github.com/prometheus-community/jiralert
RUN git clone \
    https://github.com/prometheus-community/jiralert.git .
RUN git checkout d43cbab62126d543e8e789f6374d9e745693cce2
# run just build and skip all other steps because the linter needs to much memory
RUN make build

FROM registry.access.redhat.com/ubi8-minimal:8.10-1764046129@sha256:a670c5b613280e17a666c858c9263a50aafe1a023a8d5730c7a83cb53771487b
LABEL konflux.additional-tags=1.0.0
RUN microdnf update -y \
    && rm -rf /var/cache/yum \
    && microdnf install ca-certificates
WORKDIR /
COPY --from=builder /go/src/github.com/prometheus-community/jiralert/jiralert /usr/bin
ENTRYPOINT ["/usr/bin/jiralert"]
