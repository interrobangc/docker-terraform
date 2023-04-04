.PHONY: build run

IMAGE_BASE = interrobangc
IMAGE      = terraform
MY_PWD     = $(shell pwd)

ifeq ($(TAG),)
  TAG = $(shell cat tf-version.lock)
endif

PLATFORMS  = linux/amd64,linux/arm64

BUILD_ARGS = --build-arg TERRAFORM_VERSION=$(TAG)
PLATFORM_ARG = --platform $(PLATFORMS)
IMAGE_AND_TAG = $(IMAGE_BASE)/$(IMAGE):$(TAG)

buildx-use:
	-docker buildx create --use

build: buildx-use build-local

build-local:
	docker buildx build --load $(BUILD_ARGS) -t $(IMAGE_AND_TAG) .

push: buildx-use build-and-push

build-and-push:
	docker buildx build --push $(PLATFORM_ARG) $(BUILD_ARGS) -t $(IMAGE_AND_TAG) .

shell:
	docker run -it --rm --name $(IMAGE_BASE)-$(IMAGE) $(IMAGE_BASE)/$(IMAGE) bash

shell-tag:
	docker run -it --rm --name $(IMAGE_BASE)-$(IMAGE) $(IMAGE_BASE)/$(IMAGE):${TAG} bash
