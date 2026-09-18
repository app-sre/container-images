# Konflux rebuild trigger (APPSRE-14854/APPSRE-14895): no functional change.
FROM registry.access.redhat.com/ubi9/openjdk-21-runtime:1.24-3.1789373062@sha256:f10cc334bd39f39ad35bcefc5ac0ce1ad25bda499f6abf73ccb8afdd1ea6d3c1

COPY LICENSE /licenses/LICENSE

ENV WIREMOCK_VERSION=3.3.1

WORKDIR /deployments

ADD --chmod=644 --chown=$USER:0 https://repo1.maven.org/maven2/org/wiremock/wiremock-standalone/$WIREMOCK_VERSION/wiremock-standalone-$WIREMOCK_VERSION.jar /deployments/wiremock-standalone.jar

VOLUME /deployments/mappings

VOLUME /deployments/__files

EXPOSE 8080
