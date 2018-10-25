.PHONY: build run

IMAGE_BASE = interrobangc
IMAGE      = terraform
MY_PWD     = $(shell pwd)

all: build run

build:
	docker build -t $(IMAGE_BASE)/$(IMAGE) -f $(MY_PWD)/Dockerfile $(MY_PWD)

shell:
	docker run -it --rm --name $(IMAGE_BASE)-$(IMAGE) $(IMAGE_BASE)/$(IMAGE) bash
