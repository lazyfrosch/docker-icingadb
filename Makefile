GIT_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)

ifeq ($(GIT_BRANCH),master)
  DOCKER_TAG := latest
else
  DOCKER_TAG := $(GIT_BRANCH)
endif

IMAGE := lazyfrosch/icingadb:$(DOCKER_TAG)

all: pull build

pull:
	docker pull $(IMAGE) || true

build:
	docker build --pull --force-rm --tag $(IMAGE) .

push:
	docker push $(IMAGE)
