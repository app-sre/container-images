FROM registry.access.redhat.com/ubi9/openjdk-21-runtime:1.23@sha256:14e5af876865b25abdc15c137dd30e68b3394aaee18e26bd1777036a52a907c5

COPY LICENSE /licenses/LICENSE

ENV WIREMOCK_VERSION=3.3.1

WORKDIR /deployments

ADD --chmod=644 --chown=$USER:0 https://repo1.maven.org/maven2/org/wiremock/wiremock-standalone/$WIREMOCK_VERSION/wiremock-standalone-$WIREMOCK_VERSION.jar /deployments/wiremock-standalone.jar

VOLUME /deployments/mappings

VOLUME /deployments/__files

EXPOSE 8080
