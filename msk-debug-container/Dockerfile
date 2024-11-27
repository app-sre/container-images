FROM registry.access.redhat.com/ubi9/openjdk-21@sha256:1245421ae51c94ffe6e44e7d0439b51cf2653929ecee59d881d92c09b543b52a
ARG KAFKA_VERSION
ARG KAFKA_VERSION_PATCH

LABEL konflux.additional-tags=${KAFKA_VERSION}
ENV \
    KAFKA_VERSION_FULL=${KAFKA_VERSION}.${KAFKA_VERSION_PATCH} \
    PATH=$PATH:/opt/kafka/bin

USER root
RUN microdnf --setopt=install_weak_deps=0 --setopt=tsflags=nodocs install -y \
    gzip \
    && microdnf clean all

RUN curl -sfL https://archive.apache.org/dist/kafka/${KAFKA_VERSION_FULL}/kafka_2.13-${KAFKA_VERSION_FULL}.tgz -o /tmp/kafka.tgz && \
    tar xf /tmp/kafka.tgz -C /opt && \
    rm /tmp/kafka.tgz && \
    ln -s /opt/kafka_2.13-${KAFKA_VERSION_FULL} /opt/kafka

RUN mkdir -p /licenses && ln -snf /opt/kafka/LICENSE /licenses/kafka

COPY client.properties /client.properties

# Switch back to the default user
USER ${USER}
CMD ["sleep", "infinity"]
