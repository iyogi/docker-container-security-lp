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
	@echo "Checking Dockerfile for policy compliance..."
	docker run -it --rm -v ${PWD}:/root/ projectatomic/dockerfile-lint dockerfile_lint -f Dockerfile -r policies/all_rules.yml
	@echo "Dockerfile passed all compliancy checks!"

build: lint
	@echo "Building Hugo Builder container..."
	@docker build \
		--build-arg CREATED_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
		--build-arg VCS_REF="3.0" \
		--build-arg VERSION="${VERSION}" \
		-t ${NS}/${IMAGE_NAME} .
	@docker tag ${NS}/${IMAGE_NAME} ${NS}/${IMAGE_NAME}:${VERSION}
	@echo "Hugo Builder container built. Now scanning the image for vulnerabilities"
	@docker-compose -f clair/docker-compose.yaml up -d
	sleep 5
	@docker run --rm  -v /var/run/docker.sock:/var/run/docker.sock --network=container:clair ovotech/clair-scanner clair-scanner ${NS}/${IMAGE_NAME}:${VERSION}
	@echo "No vulnerabilities found!"
	#@echo "Stopping clair (also removing caontainer - will remove also downloaded vulnerabilities database)"
	#@docker-compose -f clair/docker-compose.yaml rm -s -f
	@docker images ${NS}/${IMAGE_NAME}

run:
	docker run -d --name ${CONTAINER_NAME} --mount type=bind,src=${CONF_SRC},dst=${CONF_DST} -p 1313:1313 ${NS}/${IMAGE_NAME}:${VERSION}

push:
	docker push ${NS}/${IMAGE_NAME}:${VERSION}

release: build
	make push -e VERSION=${VERSION}


.PHONY: lint build run push release

default: build

