FROM registry.access.redhat.com/ubi8/go-toolset:1.24.6-1760634048@sha256:c7c95c4e0a1b1b0ff30d6da0eb3ae9502b2d68fdcc45a446d108066a470f4ba6 as builder
ENV GOPATH=/go/
ENV GO111MODULE=on
USER root
WORKDIR /go/src/github.com/prometheus-community/jiralert
RUN git clone \
    https://github.com/prometheus-community/jiralert.git .
RUN git checkout d43cbab62126d543e8e789f6374d9e745693cce2
# run just build and skip all other steps because the linter needs to much memory
RUN make build

FROM registry.access.redhat.com/ubi8-minimal:8.10-1759911539@sha256:58b1dc5427b699255a73475f5e96e9f658f49214e5bd56d03c534fa87980efb1
LABEL konflux.additional-tags=1.0.0
RUN microdnf update -y \
    && rm -rf /var/cache/yum \
    && microdnf install ca-certificates
WORKDIR /
COPY --from=builder /go/src/github.com/prometheus-community/jiralert/jiralert /usr/bin
ENTRYPOINT ["/usr/bin/jiralert"]
