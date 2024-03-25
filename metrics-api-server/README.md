### metrics-api-server

Simple Flask API server that provides metrics for exposing metrics to Prometheus.

This image is used where the metrics are not available to Prometheus directly,
but can be fetched from an API.

### Usage

This image is meant to be used on an OpenShift cluster, where the standard
text-based exposition file is not available.

### Testing locally

To test locally using podman, the `/data` directory is mounted to the container
as a bind mount.  For this to work properly with podman, you must pass in the
`--privileged` flag to the `podman run` command.
