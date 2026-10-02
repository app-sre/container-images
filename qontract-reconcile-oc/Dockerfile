FROM registry.access.redhat.com/ubi9/ubi:9.8-1790665138@sha256:094ea2ecfd3225af8f93807b99daa9ff33710fc705ebdf6e8466f46ed605585c
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
