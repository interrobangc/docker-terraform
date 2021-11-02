.PHONY: build run

IMAGE_BASE = interrobangc
IMAGE      = terraform
MY_PWD     = $(shell pwd)

all: build run

build:
	tag="$(TAG)"; \
	on_master=$$(git branch | grep \* | cut -d ' ' -f2 | grep master; echo $$?;); \
	if [ "$${tag-}" ]; then \
		docker build -t $(IMAGE_BASE)/$(IMAGE):$(TAG) -f $(MY_PWD)/Dockerfile $(MY_PWD); \
	elif [ "$$on_master" = "1" ]; then \
		read -n 1 -s -r -p "You are not on the master branch and did not provied a TAG={some tag} argument. Are you sure you want to build latest? Press any key to continue, ctrl+c to exit."; \
		docker build -t $(IMAGE_BASE)/$(IMAGE) -f $(MY_PWD)/Dockerfile $(MY_PWD); \
	fi;

push:
	tag="$(TAG)"; \
	on_master=$$(git branch | grep \* | cut -d ' ' -f2 | grep master; echo $$?;); \
	if [ "$${tag-}" ]; then \
		docker image push $(IMAGE_BASE)/$(IMAGE):$(TAG); \
	elif [ "$$on_master" = "1" ]; then \
		read -n 1 -s -r -p "You are not on the master branch and did not provied a TAG={some tag} argument. Are you sure you want to push latest? Press any key to continue, ctrl+c to exit."; \
		docker image push $(IMAGE_BASE)/$(IMAGE); \
	fi;

shell:
	docker run -it --rm --name $(IMAGE_BASE)-$(IMAGE) $(IMAGE_BASE)/$(IMAGE) bash

shell-tag:
	docker run -it --rm --name $(IMAGE_BASE)-$(IMAGE) $(IMAGE_BASE)/$(IMAGE):${TAG} bash
