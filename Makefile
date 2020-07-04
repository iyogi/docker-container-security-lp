####### ENV variables ##########
NS ?= iyogi
IMAGE_NAME ?= hugo-builder
VERSION ?= latest
CONF_SRC ?= /tmp/orgdocs
CONF_DST ?= /src
CONTAINER_NAME ?= hugo-builder-container

################################

lint: Dockerfile
	hadolint Dockerfile
	docker run -it --rm -v ${PWD}:/root/ projectatomic/dockerfile-lint dockerfile_lint -f Dockerfile -r policies/all_rules.yml

build: lint
	@echo "Building Hugo Builder container..."
	@docker build -t ${NS}/${IMAGE_NAME} .
	@echo "Hugo Builder container built. Now scanning the image for vulnerabilities"
	@docker-compose -f clair/docker-compose.yaml up -d
	sleep 5
	@docker run --rm  -v /var/run/docker.sock:/var/run/docker.sock --network=container:clair ovotech/clair-scanner clair-scanner ${NS}/${IMAGE_NAME}:${VERSION}
	@echo "No vulnerabilities found!"
	#@echo "Stopping clair (also removing caontainer - will remove also downloaded vulnerabilities database)"
	#@docker-compose -f clair/docker-compose.yaml rm -s -f
	@docker images ${NS}/${IMAGE_NAME}

run:
	docker run -d --name ${CONTAINER_NAME} --mount type=bind,src=${CONF_SRC},dst=${CONF_DST} -p 1313:1313 ${NS}/${IMAGE_NAME}

push:
	docker push ${NS}/${IMAGE_NAME}:${VERSION}

release: build
	make push -e VERSION=${VERSION}

.PHONY: lint build run push release

default: build

