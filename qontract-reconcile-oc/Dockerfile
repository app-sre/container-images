FROM registry.access.redhat.com/ubi9/ubi:9.5-1732804088@sha256:1057dab827c782abcfb9bda0c3900c0966b5066e671d54976a7bcb3a2d1a5e53

WORKDIR /work

ENV OC_VERSIONS="4.10.15 4.12.46"

RUN for version in ${OC_VERSIONS}; do \ 
    mkdir ${version}; \
    curl -sfL https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${version}/openshift-client-linux.tar.gz \
    -o ./${version}/oc.tar.gz && \
    tar -zvxf ./${version}/oc.tar.gz -C ./${version} && \
    rm ./${version}/oc.tar.gz && \
    rm ./${version}/README.md; \
    done
