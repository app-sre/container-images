## Prometheus CloudWatch Exporter - FIPS Red Hat Hardened Image Build

---

Alternative Dockerfile for the Prometheus CloudWatch Exporter. This build uses the Red Hat FIPS-compliant OpenJDK base Hardened Image.

## Purpose

This build repackages the upstream [prometheus/cloudwatch_exporter](https://github.com/prometheus/cloudwatch_exporter). It uses the [Red Hat FIPS validated OpenJDK runtime Hardened Image](https://images.redhat.com/?fipsOnly=true&name=openjdk).

Use this build when you need:

- A FIPS-compliant Java runtime for regulatory requirements
- Red Hat supported base images
- The same CloudWatch exporter functionality with a different JVM

The build copies the exporter JAR directly from the upstream Quay image. No source rebuild is necessary.

---



## Quick Start

```bash
# Build the image
make build

# Test it works
make test
```

---



## Updating to a New Version

Follow these steps to update the exporter version:

1. Edit `Dockerfile.hi` and change the image tags.
  For the upstream exporter:
  ```dockerfile
  FROM quay.io/prometheus/cloudwatch-exporter:<IMAGE_TAG> AS upstream
  ```
  Replace `IMAGE_TAG` with the version you want from [cloudwatch_exporter releases](https://github.com/prometheus/cloudwatch_exporter/releases).
  For the Red Hat base image:
  ```dockerfile
  FROM registry.access.redhat.com/hi/openjdk:<FIPS_IMAGE_TAG> AS runner
  ```
  Replace the `FIPS_IMAGE_TAG` with the version you want from [RH Hardened OpenJDK FIPS releases](https://images.redhat.com/?fipsOnly=true&name=openjdk).
2. Rebuild the image:
  ```bash
   make build
  ```
3. Test the new build:
  ```bash
   make test
  ```

---



## Testing

The `make test` command runs a smoke test. The test does these steps:

1. Start the container on port 9106
2. Check the logs for startup messages
3. Send a request to the health endpoint
4. Get metrics from the `/metrics` endpoint
5. Stop and remove the container

You must have a `test-config.yml` file in the repository root (This is already provided). 

This is a minimal example:

```yaml
region: us-east-1
metrics:
  - aws_namespace: AWS/EC2
    aws_metric_name: CPUUtilization
    aws_dimensions:
      - InstanceId
    aws_statistics:
      - Average
```

---



### Manual Testing

```bash
# Build
podman build -f Dockerfile.hi -t localhost/prom-cloudwatch-exporter-fips-hb:testing .

# Run with config
podman run -d --name cloudwatch-test \
  -p 9106:9106 \
  -v $(pwd)/test-config.yml:/config/config.yml:ro \
  localhost/prom-cloudwatch-exporter-fips-hb:testing

# Check metrics
curl http://localhost:9106/metrics

# Cleanup
podman stop cloudwatch-test && podman rm cloudwatch-test
```

---



### Testing with AWS Credentials

```bash
podman run -d --name cloudwatch-test \
  -p 9106:9106 \
  -e AWS_ACCESS_KEY_ID=your_key \
  -e AWS_SECRET_ACCESS_KEY=your_secret \
  -e AWS_REGION=us-east-1 \
  -v $(pwd)/test-config.yml:/config/config.yml:ro \
  localhost/prom-cloudwatch-exporter-fips-hb:testing
```

---



## Files

- `Dockerfile.hi` - FIPS-compliant build using Red Hat base images
- `Makefile` - Build and test automation
- `test-config.yml` - Minimal config for smoke tests

---



## Differences from Upstream


| Aspect        | Upstream            | This Build                 |
| ------------- | ------------------- | -------------------------- |
| Base image    | eclipse-temurin JRE | Red Hat OpenJDK FIPS       |
| FIPS mode     | No                  | Yes                        |
| JAR source    | Built from source   | Copied from upstream image |
| Functionality | Full                | Identical                  |


The application behavior is identical. Only the JVM runtime changes.