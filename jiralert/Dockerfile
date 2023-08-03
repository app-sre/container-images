FROM registry.access.redhat.com/ubi8/go-toolset:1.19.10 as builder
ENV GOPATH=/go/
ENV GO111MODULE=on
USER root
WORKDIR /go/src/github.com/prometheus-community/jiralert
RUN git clone \
    https://github.com/prometheus-community/jiralert.git .
RUN git checkout 7e2356af3ae8526235c9c4ebaf0420c9fd64b673
RUN make

FROM registry.access.redhat.com/ubi8-minimal:8.5
RUN microdnf update -y \
    && rm -rf /var/cache/yum \
    && microdnf install ca-certificates
WORKDIR /
COPY --from=builder /go/src/github.com/prometheus-community/jiralert/jiralert /usr/bin
ENTRYPOINT ["/usr/bin/jiralert"]
