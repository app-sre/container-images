FROM registry.access.redhat.com/ubi8/go-toolset:1.26.10-1794442109@sha256:0467f5aa1bc9e4ff74536ecab11dffdb6a19c2605a65d32a452d5ca7154072bd as builder
ENV GOPATH=/go/
ENV GO111MODULE=on
USER root
WORKDIR /go/src/github.com/prometheus-community/jiralert
RUN git clone \
    https://github.com/prometheus-community/jiralert.git .
RUN git checkout d43cbab62126d543e8e789f6374d9e745693cce2
# run just build and skip all other steps because the linter needs to much memory
RUN make build

FROM registry.access.redhat.com/ubi8-minimal:8.10-1794442960@sha256:b3314c5f8d009ee6df04ead732bca6d3eaf011750185e348f55fce2678fb30d0
LABEL konflux.additional-tags=1.0.1
RUN microdnf update -y \
    && rm -rf /var/cache/yum \
    && microdnf install ca-certificates
WORKDIR /
COPY --from=builder /go/src/github.com/prometheus-community/jiralert/jiralert /usr/bin
ENTRYPOINT ["/usr/bin/jiralert"]
