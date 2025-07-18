FROM registry.access.redhat.com/ubi8/go-toolset:1.24.4-1752591614@sha256:e51bf480e820ec4c656c916b837aefe4ab93c3a7c4eee030f4aa8e842a0a3c9d as builder
ENV GOPATH=/go/
ENV GO111MODULE=on
USER root
WORKDIR /go/src/github.com/prometheus-community/jiralert
RUN git clone \
    https://github.com/prometheus-community/jiralert.git .
RUN git checkout d43cbab62126d543e8e789f6374d9e745693cce2
# run just build and skip all other steps because the linter needs to much memory
RUN make build

FROM registry.access.redhat.com/ubi8-minimal:8.10-1752564239@sha256:5b195cf0b8eb2262ce81334ee44066fdb5026022803f55bfe607be7d08d4fe43
RUN microdnf update -y \
    && rm -rf /var/cache/yum \
    && microdnf install ca-certificates
WORKDIR /
COPY --from=builder /go/src/github.com/prometheus-community/jiralert/jiralert /usr/bin
ENTRYPOINT ["/usr/bin/jiralert"]
