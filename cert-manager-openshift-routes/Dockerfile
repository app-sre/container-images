FROM registry.access.redhat.com/hi/core-runtime:2.43-openssl-fips@sha256:dda4ca9f205064c1391168713fae4dfe32057f3a1e619540db34f9d167b71c74
LABEL maintainer="cert-manager Authors <cert-manager-dev@googlegroups.com>"

COPY --from=ghcr.io/cert-manager/cert-manager-openshift-routes:v0.12.0@sha256:74d1ac30480ba6a37045124cbcfc439cd8a208a4a15857698bd862c300fc2121 /ko-app/cmd /ko-app/cmd

USER 65532

ENTRYPOINT ["/ko-app/cmd"]
