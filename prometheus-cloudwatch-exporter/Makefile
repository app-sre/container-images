.PHONY: build test help

# REPO := https://github.com/prometheus/cloudwatch_exporter
IMAGE_NAME := prom-cloudwatch-exporter-fips-hb
IMAGE_TAG := testing

help:
	@echo "Usage:"
	@echo "  make build                Build container image"
	@echo "  make test                 Run container smoke test"

build:
	podman build -f Dockerfile -t localhost/$(IMAGE_NAME):$(IMAGE_TAG) .

test:
	@podman run -d --name cloudwatch-test -p 9106:9106 \
	  -v $(PWD)/test-config.yml:/config/config.yml:ro localhost/$(IMAGE_NAME):$(IMAGE_TAG)
	@sleep 2
	@echo "=== Container logs ==="
	@podman logs cloudwatch-test
	@echo "\n=== Health check ==="
	@curl -I http://localhost:9106/
	@echo "\n=== Metrics endpoint ==="
	@curl -s http://localhost:9106/metrics | head -20
	@echo "\n=== Cleanup ==="
	@podman stop cloudwatch-test
	@podman rm cloudwatch-test
	@echo "Test complete"
