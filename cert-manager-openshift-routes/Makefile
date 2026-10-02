.PHONY: build test help

IMAGE_NAME := cert-manager-openshift-routes-fips-hb
IMAGE_TAG  := testing

help:
	@echo "Usage:"
	@echo "  make build   Build container image"
	@echo "  make test    Run container smoke test"

build:
	podman build -f Dockerfile -t localhost/$(IMAGE_NAME):$(IMAGE_TAG) .

test:
	@echo "=== Test A: --help flag (expect exit 0) ==="
	podman run --rm localhost/$(IMAGE_NAME):$(IMAGE_TAG) --help
	@echo ""
	@echo "=== Test B: no kubeconfig (expect known startup error, not a crash) ==="
	@output=$$(podman run --rm localhost/$(IMAGE_NAME):$(IMAGE_TAG) 2>&1); \
	echo "$$output"; \
	echo "$$output" | grep -q "couldn't check if route.openshift.io/v1 exists in the kubernetes API" && \
	  echo "PASS: binary started and failed as expected (no cluster)" || \
	  { echo "FAIL: unexpected output"; exit 1; }
	@echo "Test complete"
