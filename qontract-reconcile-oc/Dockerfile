FROM registry.access.redhat.com/ubi9/ubi:9.5-1741850090@sha256:8d53b60617e53e4dbd6c0d485c569801f48dbeb40b48c8424a67e33a07320968

WORKDIR /work

ENV OC_VERSIONS="4.10.15 4.12.46 4.16.2"

RUN for version in ${OC_VERSIONS}; do \
    mkdir ${version}; \
    curl -sfL https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${version}/openshift-client-linux.tar.gz \
    -o ./${version}/oc.tar.gz && \
    tar -zvxf ./${version}/oc.tar.gz -C ./${version} && \
    rm ./${version}/oc.tar.gz && \
    rm ./${version}/README.md; \
    done
