FROM registry.access.redhat.com/ubi9/openjdk-21-runtime:1.24-3.1788862450@sha256:ff0a095f96c1823453008aef23b98868f3bf723fa0497d68c2fb9b1a27884064

COPY LICENSE /licenses/LICENSE

ENV WIREMOCK_VERSION=3.3.1

WORKDIR /deployments

ADD --chmod=644 --chown=$USER:0 https://repo1.maven.org/maven2/org/wiremock/wiremock-standalone/$WIREMOCK_VERSION/wiremock-standalone-$WIREMOCK_VERSION.jar /deployments/wiremock-standalone.jar

VOLUME /deployments/mappings

VOLUME /deployments/__files

EXPOSE 8080
