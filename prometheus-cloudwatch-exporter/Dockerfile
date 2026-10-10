FROM registry.access.redhat.com/hi/openjdk:25.0.4-fips@sha256:0d2d2602b843e3fc0ade4f0a9110cc43e0a485f6add1aeb7dcd1cc694c32082d
LABEL maintainer="The Prometheus Authors <prometheus-developers@googlegroups.com>"
EXPOSE 9106

USER root
WORKDIR /

RUN mkdir /config && chown 65534:65534 /config
COPY --from=quay.io/prometheus/cloudwatch-exporter:v0.18.0@sha256:da88be5880dc8413639b67904bf98525552c84282eff74e54556e00956520512 /cloudwatch_exporter.jar /cloudwatch_exporter.jar
RUN chown 65534:65534 /cloudwatch_exporter.jar

USER 65534

ENTRYPOINT [ "java", "-jar", "/cloudwatch_exporter.jar", "9106"]
CMD ["/config/config.yml"]
