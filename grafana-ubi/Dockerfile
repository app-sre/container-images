ARG GF_VERSION="11.6.3"

FROM registry.access.redhat.com/ubi9-minimal@sha256:92b1d5747a93608b6adb64dfd54515c3c5a360802db4706765ff3d8470df6290 AS downloader

ARG GF_VERSION

RUN microdnf install -y tar gzip wget && mkdir /tmp/grafana-install && \
    wget -O /tmp/grafana.tar.gz https://dl.grafana.com/oss/release/grafana-${GF_VERSION}.linux-amd64.tar.gz && \
    tar -zxvf /tmp/grafana.tar.gz --directory=/tmp/grafana-install

FROM registry.access.redhat.com/ubi9-minimal@sha256:92b1d5747a93608b6adb64dfd54515c3c5a360802db4706765ff3d8470df6290 AS base

ARG GF_VERSION
LABEL konflux.additional-tags=${GF_VERSION}

COPY LICENSE /licenses/LICENSE

ENV PATH="/usr/share/grafana/bin:$PATH" \
  GF_PATHS_CONFIG="/etc/grafana/grafana.ini" \
  GF_PATHS_DATA="/var/lib/grafana" \
  GF_PATHS_HOME="/usr/share/grafana" \
  GF_PATHS_LOGS="/var/log/grafana" \
  GF_PATHS_PLUGINS="/var/lib/grafana/plugins" \
  GF_PATHS_PROVISIONING="/etc/grafana/provisioning"

WORKDIR $GF_PATHS_HOME

COPY --from=downloader --chown=1001:0 /tmp/grafana-install/grafana-v${GF_VERSION} /usr/share/grafana/

RUN useradd -u 1001 -g 0 -r -d /usr/share/grafana -s /sbin/nologin grafana && \
    mkdir -p "$GF_PATHS_HOME/.aws" \
    "$GF_PATHS_PROVISIONING/datasources" \
    "$GF_PATHS_PROVISIONING/dashboards" \
    "$GF_PATHS_PROVISIONING/notifiers" \
    "$GF_PATHS_PROVISIONING/plugins" \
    "$GF_PATHS_PROVISIONING/access-control" \
    "$GF_PATHS_PROVISIONING/alerting" \
    "$GF_PATHS_LOGS" \
    "$GF_PATHS_PLUGINS" \
    "$GF_PATHS_DATA" && \
    cp conf/sample.ini "$GF_PATHS_CONFIG" && \
    cp conf/ldap.toml /etc/grafana/ldap.toml && \
    chown -R 1001:0 "$GF_PATHS_DATA" "$GF_PATHS_HOME/.aws" "$GF_PATHS_LOGS" "$GF_PATHS_PLUGINS" "$GF_PATHS_PROVISIONING" && \
    chmod -R 777 "$GF_PATHS_DATA" "$GF_PATHS_HOME/.aws" "$GF_PATHS_LOGS" "$GF_PATHS_PLUGINS" "$GF_PATHS_PROVISIONING" && \
    cp packaging/docker/run.sh /usr/bin/run-grafana

EXPOSE 3000

USER 1001

ENTRYPOINT ["/usr/bin/run-grafana"]
