FROM registry.access.redhat.com/ubi8/go-toolset:latest as builder
ENV GOPATH=/go/
ENV GO111MODULE=on
USER root
WORKDIR /go/src/github.com/prometheus-community/jiralert
RUN git clone \
    -b 1.1-rc1 \
    https://github.com/prometheus-community/jiralert.git .
RUN make

FROM registry.access.redhat.com/ubi8-minimal:8.2
RUN microdnf update -y \
    && rm -rf /var/cache/yum \
    && microdnf install ca-certificates
WORKDIR /
COPY --from=builder /go/src/github.com/prometheus-community/jiralert/jiralert /usr/bin
ENTRYPOINT ["/usr/bin/jiralert"]
