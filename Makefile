ELECTRUM_VERSION = $(strip $(shell cat VERSION))

GIT_COMMIT = $(strip $(shell git rev-parse --short HEAD))

DOCKER_IMAGE ?= vladfilimon/electrum-daemon
DOCKER_TAG = $(ELECTRUM_VERSION)

# Build Docker image
build: docker_build output

# Build and push Docker image
release: docker_build docker_push output

default: docker_build output

docker_build:
	@docker build \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		--build-arg VERSION=$(ELECTRUM_VERSION) \
		--build-arg VCS_REF=$(GIT_COMMIT) \
		-t $(DOCKER_IMAGE):$(DOCKER_TAG) .

docker_push:
	docker tag $(DOCKER_IMAGE):$(DOCKER_TAG) $(DOCKER_IMAGE):latest
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)
	docker push $(DOCKER_IMAGE):latest

output:
	@echo Docker Image: $(DOCKER_IMAGE):$(DOCKER_TAG)
