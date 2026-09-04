FROM registry.access.redhat.com/ubi9/openjdk-21-runtime:1.24-3.1787587037@sha256:943b19f816ea068e5f5d54ca903c65a8843e649351f85d6d0d637a3b45c0c7fc

COPY LICENSE /licenses/LICENSE

ENV WIREMOCK_VERSION=3.3.1

WORKDIR /deployments

ADD --chmod=644 --chown=$USER:0 https://repo1.maven.org/maven2/org/wiremock/wiremock-standalone/$WIREMOCK_VERSION/wiremock-standalone-$WIREMOCK_VERSION.jar /deployments/wiremock-standalone.jar

VOLUME /deployments/mappings

VOLUME /deployments/__files

EXPOSE 8080
