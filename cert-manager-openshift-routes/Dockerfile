FROM registry.access.redhat.com/hi/core-runtime:2.43-openssl-fips@sha256:dda4ca9f205064c1391168713fae4dfe32057f3a1e619540db34f9d167b71c74
LABEL maintainer="cert-manager Authors <cert-manager-dev@googlegroups.com>"

COPY --from=ghcr.io/cert-manager/cert-manager-openshift-routes:v0.11.0@sha256:a2dd73e638a498fb20046a3f212fdf930c4b9cfa58ac550d5d91432ae3e9061c /ko-app/cmd /ko-app/cmd

USER 65532

ENTRYPOINT ["/ko-app/cmd"]
