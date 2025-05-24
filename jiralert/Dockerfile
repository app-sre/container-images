FROM registry.access.redhat.com/ubi8/go-toolset:1.23.6-2.1747189110@sha256:f3bf69c758f35d8ed28ed608bf63cb44a741c06444e4b55e0fbb3044e3a47ada as builder
ENV GOPATH=/go/
ENV GO111MODULE=on
USER root
WORKDIR /go/src/github.com/prometheus-community/jiralert
RUN git clone \
    https://github.com/prometheus-community/jiralert.git .
RUN git checkout d43cbab62126d543e8e789f6374d9e745693cce2
# run just build and skip all other steps because the linter needs to much memory
RUN make build

FROM registry.access.redhat.com/ubi8-minimal:8.10-1255@sha256:b2a1bec3dfbc7a14a1d84d98934dfe8fdde6eb822a211286601cf109cbccb075
RUN microdnf update -y \
    && rm -rf /var/cache/yum \
    && microdnf install ca-certificates
WORKDIR /
COPY --from=builder /go/src/github.com/prometheus-community/jiralert/jiralert /usr/bin
ENTRYPOINT ["/usr/bin/jiralert"]
