FROM registry.access.redhat.com/hi/openjdk:25.0.4-fips@sha256:a6af3f3ace0e8fd979be4ee1967fbf2900eaa233aace58172dec6e87d77d3651
LABEL maintainer="The Prometheus Authors <prometheus-developers@googlegroups.com>"
EXPOSE 9106

USER root
WORKDIR /

RUN mkdir /config && chown 65534:65534 /config
COPY --from=quay.io/prometheus/cloudwatch-exporter:v0.19.0@sha256:0f7e1251bee8ac34661ca77319f40f3f74af66fb101937927248e4cc76369118 /cloudwatch_exporter.jar /cloudwatch_exporter.jar
RUN chown 65534:65534 /cloudwatch_exporter.jar

USER 65534

ENTRYPOINT [ "java", "-jar", "/cloudwatch_exporter.jar", "9106"]
CMD ["/config/config.yml"]
