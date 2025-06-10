ARG GF_VERSION="10.4.1"

FROM registry.access.redhat.com/ubi9-minimal@sha256:92b1d5747a93608b6adb64dfd54515c3c5a360802db4706765ff3d8470df6290 AS downloader

ARG GF_VERSION

RUN microdnf install -y tar gzip wget && mkdir /tmp/grafana-install && \
    wget -O /tmp/grafana.tar.gz https://dl.grafana.com/oss/release/grafana-${GF_VERSION}.linux-amd64.tar.gz && \
    tar -zxvf /tmp/grafana.tar.gz --directory=/tmp/grafana-install

FROM registry.access.redhat.com/ubi9-minimal@sha256:92b1d5747a93608b6adb64dfd54515c3c5a360802db4706765ff3d8470df6290 AS base

ARG GF_VERSION
USER root

COPY --from=downloader /tmp/grafana-install/grafana-v${GF_VERSION} /usr/share/grafana/

RUN mkdir /etc/grafana /var/lib/grafana /var/log/grafana && \
    useradd -u 1001 -g 0 -r -d /usr/share/grafana -s /sbin/nologin grafana && \
    microdnf install -y wget && microdnf upgrade -y && microdnf clean all && \
    chgrp -R 0 /etc/grafana /var/lib/grafana /var/log/grafana /usr/share/grafana && \
    chmod -R g=u /var/lib/grafana /var/log/grafana /usr/share/grafana

RUN wget https://raw.githubusercontent.com/grafana/grafana/refs/tags/v${GF_VERSION}/packaging/docker/run.sh -O usr/bin/run-grafana && chmod +x /usr/bin/run-grafana

VOLUME ["/etc/grafana"]
VOLUME ["/etc/grafana/provisioning/datasources"]
VOLUME ["/etc/grafana/provisioning/dashboards"]
VOLUME ["/etc/grafana/provisioning/notifiers"]
VOLUME ["/grafana-dashboard-definitions"]

COPY LICENSE /licenses/LICENSE

EXPOSE 3000

USER 1001
WORKDIR /usr/share/grafana

ENV PATH="/usr/share/grafana/bin:$PATH" \
  GF_PATHS_CONFIG="/etc/grafana/grafana.ini" \
  GF_PATHS_DATA="/var/lib/grafana" \
  GF_PATHS_HOME="/usr/share/grafana" \
  GF_PATHS_LOGS="/var/log/grafana" \
  GF_PATHS_PLUGINS="/var/lib/grafana/plugins" \
  GF_PATHS_PROVISIONING="/etc/grafana/provisioning"

ENTRYPOINT ["/usr/bin/run-grafana"]
