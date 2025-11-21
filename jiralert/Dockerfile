FROM registry.access.redhat.com/ubi8/go-toolset:1.24.6-1762258331@sha256:258e9a3fb96c4cf4ed0a7947e26f47f1af0a548ecd5d22b3a029a41328a90409 as builder
ENV GOPATH=/go/
ENV GO111MODULE=on
USER root
WORKDIR /go/src/github.com/prometheus-community/jiralert
RUN git clone \
    https://github.com/prometheus-community/jiralert.git .
RUN git checkout d43cbab62126d543e8e789f6374d9e745693cce2
# run just build and skip all other steps because the linter needs to much memory
RUN make build

FROM registry.access.redhat.com/ubi8-minimal:8.10-1763613452@sha256:99a9bb620c4c5eb82c67dc270b58304e0e936894c85aeec67e7638a19ce6a97e
LABEL konflux.additional-tags=1.0.0
RUN microdnf update -y \
    && rm -rf /var/cache/yum \
    && microdnf install ca-certificates
WORKDIR /
COPY --from=builder /go/src/github.com/prometheus-community/jiralert/jiralert /usr/bin
ENTRYPOINT ["/usr/bin/jiralert"]
