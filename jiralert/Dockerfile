FROM registry.access.redhat.com/ubi8/go-toolset:1.23.9-2.1751403850@sha256:d7d5a44b6f80c0c365c9d21ded6f97edf7a7503c15066b770db8b37d2deebccd as builder
ENV GOPATH=/go/
ENV GO111MODULE=on
USER root
WORKDIR /go/src/github.com/prometheus-community/jiralert
RUN git clone \
    https://github.com/prometheus-community/jiralert.git .
RUN git checkout d43cbab62126d543e8e789f6374d9e745693cce2
# run just build and skip all other steps because the linter needs to much memory
RUN make build

FROM registry.access.redhat.com/ubi8-minimal:8.10-1295.1749680713@sha256:fceb1f445ccd61a60d91d404fd76dbebaf3403e6cc2219cf6d6af4fd4bf7df6a
RUN microdnf update -y \
    && rm -rf /var/cache/yum \
    && microdnf install ca-certificates
WORKDIR /
COPY --from=builder /go/src/github.com/prometheus-community/jiralert/jiralert /usr/bin
ENTRYPOINT ["/usr/bin/jiralert"]
