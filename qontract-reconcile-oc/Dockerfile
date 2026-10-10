FROM registry.access.redhat.com/ubi9/ubi:9.8-1791269371@sha256:5858f9ace07316e3b12caab62f6c2481a5030bb6bafdca5a9ea324c321ef36df
LABEL konflux.additional-tags=1.0.2

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
