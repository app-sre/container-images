FROM registry.access.redhat.com/ubi8/go-toolset:1.24.4-1752145223@sha256:621eebfdfc044df4bd4b50ec11f8791bc68986a7b0aa00089777b17bd2e9c751 as builder
ENV GOPATH=/go/
ENV GO111MODULE=on
USER root
WORKDIR /go/src/github.com/prometheus-community/jiralert
RUN git clone \
    https://github.com/prometheus-community/jiralert.git .
RUN git checkout d43cbab62126d543e8e789f6374d9e745693cce2
# run just build and skip all other steps because the linter needs to much memory
RUN make build

FROM registry.access.redhat.com/ubi8-minimal:8.10-1752068421@sha256:9746f7ac575b4427fc9635f8f575289870a8b30dabf77ee992ae4c2f1e121cce
RUN microdnf update -y \
    && rm -rf /var/cache/yum \
    && microdnf install ca-certificates
WORKDIR /
COPY --from=builder /go/src/github.com/prometheus-community/jiralert/jiralert /usr/bin
ENTRYPOINT ["/usr/bin/jiralert"]
