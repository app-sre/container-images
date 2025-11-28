FROM registry.access.redhat.com/ubi9/openjdk-21-runtime:1.23-6.1763034977@sha256:7ca4874ffc223925d225d636bac6fa302a09a4f3534ab4e072a6b75ee28d5415

COPY LICENSE /licenses/LICENSE

ENV WIREMOCK_VERSION=3.3.1

WORKDIR /deployments

ADD --chmod=644 --chown=$USER:0 https://repo1.maven.org/maven2/org/wiremock/wiremock-standalone/$WIREMOCK_VERSION/wiremock-standalone-$WIREMOCK_VERSION.jar /deployments/wiremock-standalone.jar

VOLUME /deployments/mappings

VOLUME /deployments/__files

EXPOSE 8080
