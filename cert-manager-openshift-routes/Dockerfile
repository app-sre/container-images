FROM registry.access.redhat.com/hi/core-runtime:2.43-openssl-fips@sha256:215eb859af19b0c0b798116ef5ede2e98927b0371f05fe0a0befbcb1efd4168d
LABEL maintainer="cert-manager Authors <cert-manager-dev@googlegroups.com>"

COPY --from=ghcr.io/cert-manager/cert-manager-openshift-routes:v0.12.0@sha256:651561a4e924ff70042b7454a94c1678337dc5614ef5a1ab6969755583eb4149 /ko-app/cmd /ko-app/cmd

USER 65532

ENTRYPOINT ["/ko-app/cmd"]
