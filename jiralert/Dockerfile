FROM registry.access.redhat.com/ubi8/go-toolset:1.26.7-1788328948@sha256:7b04f42022fe4b89a08e5737fe8b289e329209d2c69a43188d6b9c76de92b558 as builder
ENV GOPATH=/go/
ENV GO111MODULE=on
USER root
WORKDIR /go/src/github.com/prometheus-community/jiralert
RUN git clone \
    https://github.com/prometheus-community/jiralert.git .
RUN git checkout d43cbab62126d543e8e789f6374d9e745693cce2
# run just build and skip all other steps because the linter needs to much memory
RUN make build

FROM registry.access.redhat.com/ubi8-minimal:8.10-1788917281@sha256:4e4bb2f1d53efe9a198adc197037aa2d63f113f90911d7d074bf43bb732ed8f0
LABEL konflux.additional-tags=1.0.0
RUN microdnf update -y \
    && rm -rf /var/cache/yum \
    && microdnf install ca-certificates
WORKDIR /
COPY --from=builder /go/src/github.com/prometheus-community/jiralert/jiralert /usr/bin
ENTRYPOINT ["/usr/bin/jiralert"]
