# Konflux rebuild trigger (APPSRE-14854/APPSRE-14895): no functional change.
FROM registry.access.redhat.com/ubi9/openjdk-21-runtime:1.24-3.1794341129@sha256:9a074c2ff90be60b12521ffd5e531acafd25fe36f1c177180cbe1176dfb36c84

COPY LICENSE /licenses/LICENSE

ENV WIREMOCK_VERSION=3.3.1

WORKDIR /deployments

ADD --chmod=644 --chown=$USER:0 https://repo1.maven.org/maven2/org/wiremock/wiremock-standalone/$WIREMOCK_VERSION/wiremock-standalone-$WIREMOCK_VERSION.jar /deployments/wiremock-standalone.jar

VOLUME /deployments/mappings

VOLUME /deployments/__files

EXPOSE 8080
