FROM registry.access.redhat.com/ubi8/go-toolset:1.26.11-1795526965@sha256:6d44a807565fca5e364815d62e11d4d7a3730277bb3c189a21defd703b475ad0 as builder
ENV GOPATH=/go/
ENV GO111MODULE=on
USER root
WORKDIR /go/src/github.com/prometheus-community/jiralert
RUN git clone \
    https://github.com/prometheus-community/jiralert.git .
RUN git checkout d43cbab62126d543e8e789f6374d9e745693cce2
# run just build and skip all other steps because the linter needs to much memory
RUN make build

FROM registry.access.redhat.com/ubi8-minimal:8.10-1795498801@sha256:1068268a5dc71d7b392ab17c07de3ebf64e18d7f34e9b63d213b0a9008993ec1
LABEL konflux.additional-tags=1.0.1
RUN microdnf update -y \
    && rm -rf /var/cache/yum \
    && microdnf install ca-certificates
WORKDIR /
COPY --from=builder /go/src/github.com/prometheus-community/jiralert/jiralert /usr/bin
ENTRYPOINT ["/usr/bin/jiralert"]
