FROM registry.access.redhat.com/ubi8/go-toolset:1.26.10-1793808960@sha256:1a0bd73ea52b93dffbd0175726a9cdcfa3f83ce374e9bee455303ecfd12897ba as builder
ENV GOPATH=/go/
ENV GO111MODULE=on
USER root
WORKDIR /go/src/github.com/prometheus-community/jiralert
RUN git clone \
    https://github.com/prometheus-community/jiralert.git .
RUN git checkout d43cbab62126d543e8e789f6374d9e745693cce2
# run just build and skip all other steps because the linter needs to much memory
RUN make build

FROM registry.access.redhat.com/ubi8-minimal:8.10-1793860563@sha256:7c5f7ae1bcad8d2ebbc364bb8f62c76f50e5666062a65a5cc969d9d1e54ce0d8
LABEL konflux.additional-tags=1.0.1
RUN microdnf update -y \
    && rm -rf /var/cache/yum \
    && microdnf install ca-certificates
WORKDIR /
COPY --from=builder /go/src/github.com/prometheus-community/jiralert/jiralert /usr/bin
ENTRYPOINT ["/usr/bin/jiralert"]
