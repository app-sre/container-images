FROM registry.access.redhat.com/ubi9/ubi-minimal:9.5-1742914212@sha256:ac61c96b93894b9169221e87718733354dd3765dd4a62b275893c7ff0d876869

COPY LICENSE /licenses/LICENSE

# Install Java
RUN microdnf install -y java-17-openjdk-headless && \
    microdnf clean all

# Download WireMock standalone JAR
ENV WIREMOCK_VERSION=3.3.1
RUN set -eux && \
  curl -L -f -o /tmp/wiremock-standalone.jar \
  https://repo1.maven.org/maven2/org/wiremock/wiremock-standalone/${WIREMOCK_VERSION}/wiremock-standalone-${WIREMOCK_VERSION}.jar && \
  chmod +x /tmp/wiremock-standalone.jar

# Create WireMock directories and copy mappings
RUN mkdir -p /wiremock/mappings /wiremock/__files

# Create WireMock startup script
RUN printf '#!/bin/sh\n\
  set -e\n\
  \n\
  exec java \\\n\
  -jar /tmp/wiremock-standalone.jar \\\n\
  --port 8088 \\\n\
  --root-dir /wiremock \\\n\
  --global-response-templating \\\n\
  --verbose\n' > /usr/local/bin/wiremock && \
  chmod +x /usr/local/bin/wiremock

# Set ownership of WireMock directories and files for user 1001
RUN chown -R 1001:1001 /wiremock /tmp/wiremock-standalone.jar

USER 1001

ENTRYPOINT ["/usr/local/bin/wiremock"]
