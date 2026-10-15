.PHONY: build test help

IMAGE_NAME := k8s-sidecar-fips
IMAGE_TAG := testing
IMAGE := localhost/$(IMAGE_NAME):$(IMAGE_TAG)

help:
	@echo "Container runtime: $(CONTAINER_CMD) (override with CONTAINER_CMD=...)"
	@echo "Usage:"
	@echo "  make build    Build container image"
	@echo "  make test     Run container smoke test"

build:
	$(CONTAINER_CMD) build -f Dockerfile -t $(IMAGE) .

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
# Test B: cryptography is linked against the system (FIPS) OpenSSL, not a
#   vendored/static wheel OpenSSL. See check_cryptography_openssl.py.
#
# Test C: Sidecar startup behavior without a cluster
#   Runs the container with its default entrypoint (sidecar.py) and no
#   environment variables set. The sidecar requires a LABEL env var to know
#   which configmaps/secrets to watch; without it, it logs a CRITICAL message
#   and exits immediately. We capture stdout+stderr and grep for that known
#   message to confirm the binary started correctly and failed as expected,
#   rather than crashing due to a missing dep or broken entrypoint.
#   A match = PASS. Any other output = FAIL.

test:
	@echo "=== Test A: Python imports (expect exit 0) ==="
	$(CONTAINER_CMD) run --rm --entrypoint python $(IMAGE) -c \
	  "import kubernetes, requests, pythonjsonlogger, logfmter, pyasn1; print('deps ok')"
	@echo ""
	@echo "=== Test B: cryptography uses system OpenSSL (expect exit 0) ==="
	$(CONTAINER_CMD) run --rm -v $(CURDIR)/check_cryptography_openssl.py:/tmp/check_cryptography_openssl.py:ro \
	  --entrypoint python $(IMAGE) /tmp/check_cryptography_openssl.py
	@echo ""
	@echo "=== Test C: no kubeconfig (expect known startup error, not a crash) ==="
	@output=$$($(CONTAINER_CMD) run --rm $(IMAGE) 2>&1); \
	echo "$$output"; \
	echo "$$output" | grep -q "Should have added {LABEL} as environment variable" && \
	  echo "PASS: binary started and failed as expected (no LABEL env)" || \
	  { echo "FAIL: unexpected output"; exit 1; }
	@echo "Test complete"
