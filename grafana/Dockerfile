FROM registry.redhat.io/rhel9/grafana@sha256:079d6b4e15746dd6b070430bb15a210ff73c5b2e73a2a68480a005ac44e450b7

ENV GF_VERSION="10.4.1"

USER root

RUN dnf install -y wget

RUN wget -q -O grafana.key https://rpm.grafana.com/gpg.key && rpm --import grafana.key && \
    dnf config-manager --add-repo https://rpm.grafana.com && rm grafana.key

RUN dnf install -y grafana-${GF_VERSION}

USER 1001
WORKDIR /usr/share/grafana
ENTRYPOINT ["/usr/bin/run-grafana"]
