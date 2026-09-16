FROM registry.access.redhat.com/hi/openjdk:25.0.4-fips
LABEL maintainer="The Prometheus Authors <prometheus-developers@googlegroups.com>"
EXPOSE 9106

USER root
WORKDIR /

RUN mkdir /config && chown 65534:65534 /config
COPY --from=quay.io/prometheus/cloudwatch-exporter:v0.18.0 /cloudwatch_exporter.jar /cloudwatch_exporter.jar
RUN chown 65534:65534 /cloudwatch_exporter.jar

USER 65534

ENTRYPOINT [ "java", "-jar", "/cloudwatch_exporter.jar", "9106"]
CMD ["/config/config.yml"]
