FROM registry.access.redhat.com/ubi8/go-toolset:1.24.4-1754557074@sha256:45c232cb9eb2400b8c7a9906daee381b057a55ee60b6a59b7035b471b4d919f4 as builder
ENV GOPATH=/go/
ENV GO111MODULE=on
USER root
WORKDIR /go/src/github.com/prometheus-community/jiralert
RUN git clone \
    https://github.com/prometheus-community/jiralert.git .
RUN git checkout d43cbab62126d543e8e789f6374d9e745693cce2
# run just build and skip all other steps because the linter needs to much memory
RUN make build

FROM registry.access.redhat.com/ubi8-minimal:8.10-1754402686@sha256:319057f561604173dc6a4c3648295159d34b1c7996f526a1e0c2352309dbb2dd
LABEL konflux.additional-tags=1.0.0
RUN microdnf update -y \
    && rm -rf /var/cache/yum \
    && microdnf install ca-certificates
WORKDIR /
COPY --from=builder /go/src/github.com/prometheus-community/jiralert/jiralert /usr/bin
ENTRYPOINT ["/usr/bin/jiralert"]
