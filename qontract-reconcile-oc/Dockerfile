FROM registry.access.redhat.com/ubi9/ubi:9.7-1763340522@sha256:dcd8128d7620b06e4bce291f30db6ffcfa339b04e6d66081e36eb8e2b1b700f8
LABEL konflux.additional-tags=1.0.1

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
