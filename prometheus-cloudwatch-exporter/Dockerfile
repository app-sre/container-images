FROM registry.access.redhat.com/hi/openjdk:25.0.4-fips@sha256:30e4778d6192f72a8fa6cdc2828dd00d063263af78575ead2a31e6e72c80d137
LABEL maintainer="The Prometheus Authors <prometheus-developers@googlegroups.com>"
EXPOSE 9106

USER root
WORKDIR /

RUN mkdir /config && chown 65534:65534 /config
COPY --from=quay.io/prometheus/cloudwatch-exporter:v0.19.0@sha256:9180fd134c5149293c1819c9e1cbc7d08381616d5e7d1740e2d53ddde74b5b4c /cloudwatch_exporter.jar /cloudwatch_exporter.jar
RUN chown 65534:65534 /cloudwatch_exporter.jar

USER 65534

ENTRYPOINT [ "java", "-jar", "/cloudwatch_exporter.jar", "9106"]
CMD ["/config/config.yml"]
