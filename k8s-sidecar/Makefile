.PHONY: build test help

IMAGE_NAME := k8s-sidecar-fips
IMAGE_TAG := testing

help:
	@echo "Usage:"
	@echo "  make build    Build container image"
	@echo "  make test     Run container smoke test"

build:
	podman build -f Dockerfile -t localhost/$(IMAGE_NAME):$(IMAGE_TAG) .

# Smoke test the locally built image.
#
# Two tests are run:
#
# Test A: Python dependency imports
#   Overrides the default entrypoint (sidecar.py) to run a bare Python -c
#   import check. Validates that all five required packages were installed
#   correctly into the venv during the build:
#     - kubernetes        (k8s API client)
#     - requests          (HTTP library)
#     - pythonjsonlogger  (structured JSON logging; pip name: python-json-logger)
#     - logfmter          (logfmt formatter)
#     - pyasn1            (ASN.1 library, required by kubernetes client)
#   Exit 0 = pass. Any ImportError = build is broken.
#
# Test B: Sidecar startup behavior without a cluster
#   Runs the container with its default entrypoint (sidecar.py) and no
#   environment variables set. The sidecar requires a LABEL env var to know
#   which configmaps/secrets to watch; without it, it logs a CRITICAL message
#   and exits immediately. We capture stdout+stderr and grep for that known
#   message to confirm the binary started correctly and failed as expected,
#   rather than crashing due to a missing dep or broken entrypoint.
#   A match = PASS. Any other output = FAIL.

test:
	@echo "=== Test A: Python imports (expect exit 0) ==="
	podman run --rm --entrypoint python localhost/$(IMAGE_NAME):$(IMAGE_TAG) -c \
	  "import kubernetes, requests, pythonjsonlogger, logfmter, pyasn1; print('deps ok')"
	@echo ""
	@echo "=== Test B: no kubeconfig (expect known startup error, not a crash) ==="
	@output=$$(podman run --rm localhost/$(IMAGE_NAME):$(IMAGE_TAG) 2>&1); \
	echo "$$output"; \
	echo "$$output" | grep -q "Should have added {LABEL} as environment variable" && \
	  echo "PASS: binary started and failed as expected (no LABEL env)" || \
	  { echo "FAIL: unexpected output"; exit 1; }
	@echo "Test complete"
