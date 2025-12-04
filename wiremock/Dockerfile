FROM registry.access.redhat.com/ubi9/openjdk-21-runtime:1.23-6.1764562148@sha256:c9e38301c31ba579c9e766acb9e80415d925ea50a1b68b560cf7f3e75b6fa8dc

COPY LICENSE /licenses/LICENSE

ENV WIREMOCK_VERSION=3.3.1

WORKDIR /deployments

ADD --chmod=644 --chown=$USER:0 https://repo1.maven.org/maven2/org/wiremock/wiremock-standalone/$WIREMOCK_VERSION/wiremock-standalone-$WIREMOCK_VERSION.jar /deployments/wiremock-standalone.jar

VOLUME /deployments/mappings

VOLUME /deployments/__files

EXPOSE 8080
