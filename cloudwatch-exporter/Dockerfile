ARG VERSION=v0.16.0

FROM registry.access.redhat.com/ubi9/ubi-minimal:9.5-1731593028 as license

RUN microdnf install -y git

WORKDIR /workdir
RUN git clone https://github.com/prometheus/cloudwatch_exporter.git /workdir/cloudwatch_exporter && \
    cd /workdir/cloudwatch_exporter && \
    git checkout $VERSION

FROM registry.access.redhat.com/ubi9/openjdk-21-runtime:1.21-1

COPY --from=license /workdir/cloudwatch_exporter/LICENSE /licenses/LICENSE

LABEL konflux.additional-tags="${VERSION}"

EXPOSE 9106

RUN mkdir /home/default/config

# COPY does not like vars expansion
COPY --from=prom/cloudwatch-exporter:v0.16.0 /cloudwatch_exporter.jar /home/default/cloudwatch_exporter.jar

ENTRYPOINT [ "java", "-jar", "/home/default/cloudwatch_exporter.jar", "9106"]
CMD ["/home/default/config/config.yml"]
