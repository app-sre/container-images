FROM registry.access.redhat.com/ubi8/go-toolset:1.23.9-2.1749483526@sha256:f79e40e156b5c887b1e12ae7a2f6c59b0f720e9fc7874a328a1d76e558297f48 as builder
ENV GOPATH=/go/
ENV GO111MODULE=on
USER root
WORKDIR /go/src/github.com/prometheus-community/jiralert
RUN git clone \
    https://github.com/prometheus-community/jiralert.git .
RUN git checkout d43cbab62126d543e8e789f6374d9e745693cce2
# run just build and skip all other steps because the linter needs to much memory
RUN make build

FROM registry.access.redhat.com/ubi8-minimal:8.10-1295@sha256:73064ec359dcd71e56677f8173a134809c885484ba89e6a137d33521ad29dd4c
RUN microdnf update -y \
    && rm -rf /var/cache/yum \
    && microdnf install ca-certificates
WORKDIR /
COPY --from=builder /go/src/github.com/prometheus-community/jiralert/jiralert /usr/bin
ENTRYPOINT ["/usr/bin/jiralert"]
