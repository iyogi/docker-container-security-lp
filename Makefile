####### ENV variables ##########
NS ?= iyogi
IMAGE_NAME ?= hugo-builder
VERSION ?= latest
CONF_SRC ?= /tmp/orgdocs
CONF_DST ?= /src
CONTAINER_NAME ?= hugo-builder-container

################################

build:
	@echo "Building Hugo Builder container..."
	@docker build -t ${NS}/${IMAGE_NAME} .
	@echo "Hugo Builder container built!"
	@docker images ${NS}/${IMAGE_NAME}

run:
	docker run -d --name ${CONTAINER_NAME} --mount type=bind,src=${CONF_SRC},dst=${CONF_DST} -p 1313:1313 ${NS}/${IMAGE_NAME}

push:
	docker push ${NS}/${IMAGE_NAME}:${VERSION}

release: build
	make push -e VERSION=${VERSION}

.PHONY: build run push release

default: build

