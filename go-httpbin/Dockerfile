FROM registry.access.redhat.com/ubi9/go-toolset@sha256:e0ad156b08e0b50ad509d79513e13e8a31f2812c66e9c48c98cea53420ec2bca AS builder
ENV GOPATH=/go/
ENV GO111MODULE=on
USER root
RUN go install github.com/mccutchen/go-httpbin/v2/cmd/go-httpbin@1379030f736582bb5c9745dc5d85df9a2b41887a

FROM registry.access.redhat.com/ubi9@sha256:304b50df1ea4db9706d8a30f4bbf26f582936ebc80c7e075c72ff2af99292a54
RUN dnf update -y \
    && rm -rf /var/cache/yum \
    && dnf install ca-certificates
WORKDIR /
COPY --from=builder /go/bin/go-httpbin /usr/bin
ENTRYPOINT ["/usr/bin/go-httpbin"]