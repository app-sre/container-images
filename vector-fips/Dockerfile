FROM registry.access.redhat.com/ubi9/ubi:9.4

WORKDIR /opt/vector

ENV VECTOR_VERSION="0.41.1"

RUN rpm -i https://yum.vector.dev/stable/vector-0/x86_64/vector-${VECTOR_VERSION}-1.x86_64.rpm

COPY openssl-fips.cnf .

ENV OPENSSL_CONF=/opt/vector/openssl-fips.cnf
ENV OPENSSL_MODULES=/usr/lib64/ossl-modules/

ENTRYPOINT ["/usr/bin/vector"]
