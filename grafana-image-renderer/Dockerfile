# grafana-image-renderer - UBI9 + Chrome for Testing
#
# Builds grafana-image-renderer from source and runs it in a UBI9 environment
# with Chrome for Testing headless shell.
#
# Using Chrome for Testing instead of EPEL chromium because EPEL chromium
# has unmet dependencies (pipewire-libs, bluez-libs) not available in UBI/EPEL.

ARG VERSION="5.8.3"
ARG CHROME_VERSION="148.0.7778.96"

# Build stage - compile Go binary from source
FROM registry.access.redhat.com/ubi9/go-toolset:1.25.8@sha256:75ecb48dfaec6655bd589091902e3b9328c300befba34cb06fc5e7323099e17d AS builder

ARG VERSION

USER 0

# Clone grafana-image-renderer at specific version
RUN git clone --depth 1 --branch v${VERSION} \
    https://github.com/grafana/grafana-image-renderer.git /workspace/grafana-image-renderer

WORKDIR /workspace/grafana-image-renderer

# Build statically linked binary for portability
# GOTOOLCHAIN must match upstream go.mod requirement (enforced since Go 1.21)
# When updating VERSION, check upstream go.mod and update GOTOOLCHAIN (e.g., v5.6.3 → go1.25.6, v5.8.3 → go1.26.2)
RUN CGO_ENABLED=0 GOTOOLCHAIN=go1.26.2 go build \
    -o grafana-image-renderer \
    -buildvcs=false \
    -ldflags '-s -w -extldflags "-static"' \
    .

# Runtime stage - UBI9 minimal
# Using Chrome for Testing instead of EPEL chromium to avoid missing dependencies
FROM registry.access.redhat.com/ubi9-minimal@sha256:92b1d5747a93608b6adb64dfd54515c3c5a360802db4706765ff3d8470df6290

ARG VERSION
ARG CHROME_VERSION
LABEL org.opencontainers.image.source="https://github.com/app-sre/container-images/tree/master/grafana-image-renderer"
LABEL konflux.additional-tags=${VERSION}

COPY LICENSE /licenses/LICENSE

# Install Chrome for Testing
# Using Chrome instead of EPEL chromium to avoid missing dependencies (pipewire, bluetooth libs)
RUN microdnf install -y wget unzip && \
    wget -q "https://storage.googleapis.com/chrome-for-testing-public/${CHROME_VERSION}/linux64/chrome-headless-shell-linux64.zip" -O /tmp/chrome.zip && \
    unzip -q /tmp/chrome.zip -d /opt && \
    mv /opt/chrome-headless-shell-linux64 /opt/chrome && \
    rm /tmp/chrome.zip && \
    # Install fonts and minimal dependencies
    microdnf install -y \
    dejavu-sans-mono-fonts \
    dejavu-serif-fonts \
    liberation-mono-fonts \
    liberation-fonts-common \
    glibc-langpack-en \
    ca-certificates \
    # Required libraries for Chrome
    nss \
    atk \
    at-spi2-atk \
    cups-libs \
    libdrm \
    mesa-libgbm \
    libxkbcommon \
    gtk3 \
    && microdnf clean all

# Configure locale for UTF-8 support
ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

# Create non-root user following OpenShift conventions
# UID 65532 matches upstream, GID 0 follows OpenShift best practices
RUN useradd --uid 65532 --gid 0 --no-create-home --home-dir /home/nonroot nonroot && \
    mkdir -p /home/nonroot && \
    chgrp -R 0 /home/nonroot && \
    chmod -R g=u /home/nonroot

WORKDIR /home/nonroot
USER 65532

# Copy the compiled binary from builder
COPY --from=builder /workspace/grafana-image-renderer/grafana-image-renderer /usr/bin/grafana-image-renderer

EXPOSE 8081

# Configure browser path for grafana-image-renderer
# Chrome for Testing headless shell
ENV BROWSER_PATH="/opt/chrome/chrome-headless-shell"

ENTRYPOINT ["/usr/bin/grafana-image-renderer"]
CMD ["server"]
