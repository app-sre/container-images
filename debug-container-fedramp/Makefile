.PHONY: build login push


IMAGE_NAME := quay.io/app-sre/debug-container-fedramp
IMAGE_TAG := $(shell git rev-parse --short=7 HEAD) 

build:
	@docker build -t $(IMAGE):$(IMAGE_TAG) .

login: check-env-push
ifndef QUAY_USER
	$(error QUAY_USER not defined)
endif
ifndef QUAY_TOKEN
	$(error QUAY_TOKEN not defined)
endif
	@docker login -u $(QUAY_USER) -p $(QUAY_TOKEN) quay.io

push:
	@docker push $(IMAGE_NAME):$(IMAGE_TAG)
