FROM registry.access.redhat.com/ubi9/ubi:9.7-1764163501@sha256:75937d9d75e976023814c7b8418016148c70b53fdbd7493636980a0de2126bdc
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
