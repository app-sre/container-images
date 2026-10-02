FROM registry.access.redhat.com/hi/core-runtime:2.43-openssl-fips
LABEL maintainer="cert-manager Authors <cert-manager-dev@googlegroups.com>"

COPY --from=ghcr.io/cert-manager/cert-manager-openshift-routes:v0.11.0 /ko-app/cmd /ko-app/cmd

USER 65532

ENTRYPOINT ["/ko-app/cmd"]
