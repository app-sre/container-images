# Grafana Image Renderer

UBI9-based container image for [grafana-image-renderer](https://github.com/grafana/grafana-image-renderer), a headless browser service for rendering Grafana dashboards as images.

## Purpose

This image provides the grafana-image-renderer service built from source with Chrome for Testing headless shell. It is used by Grafana instances to render panels and dashboards as PNG/PDF images.

## Image Details

- **Base Image**: UBI9 (Red Hat Universal Base Image 9)
- **Browser**: Chrome for Testing headless shell
- **Build Method**: Multi-stage build — Go binary compiled from source, Chrome downloaded directly from Google's testing repository

## Why Chrome for Testing?

Chromium is not available in standard UBI repositories. While EPEL provides chromium packages, they have unmet dependencies (`pipewire-libs`, `bluez-libs`) that are not available in UBI or EPEL repositories, making installation impossible.

Chrome for Testing is Google's official browser distribution for automated testing. It provides a stable, headless-capable browser without the dependency conflicts of EPEL chromium.

## Updating

To update to a new version of grafana-image-renderer:

1. Update `GIR_VERSION` in the Dockerfile
2. Optionally update `CHROME_VERSION` to match upstream requirements (see [Chrome for Testing versions](https://googlechromelabs.github.io/chrome-for-testing/))

## Usage

The image runs grafana-image-renderer on port 8081 and can be configured via environment variables. See the [upstream documentation](https://github.com/grafana/grafana-image-renderer/blob/master/docs/sources/_index.md) for configuration details.
