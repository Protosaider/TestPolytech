# include make_env

.PHONY: build push pull restart run stop login clean release tag

MAKEFILE_JUSTNAME = $(firstword $(MAKEFILE_LIST))
MAKEFILE_COMPLETE = $(CURDIR)/$(MAKEFILE_JUSTNAME)

$(info DIRECTORY $(CURDIR))

# Image and binary can be overidden with env vars.
DOCKER_IMAGE ?= workinghandguard/test
# DOCKER_TAG ?= default
CONTAINER_NAME ?= test

# Get the latest commit.
GIT_COMMIT = $(strip $(shell git rev-parse --short HEAD))

# Get the version number from the code
###
# CODE_VERSION = $(strip $(shell cat VERSION))
### 
#WIN
###
CODE_VERSION = $(strip $(shell type VERSION))
###
#

# Find out if the working directory is clean
GIT_NOT_CLEAN_CHECK = $(shell git status --porcelain)

ifneq (x$(GIT_NOT_CLEAN_CHECK), x)
	DOCKER_TAG_SUFFIX = -dirty
endif


# If we're releasing to Docker Hub, and we're going to mark it with the latest tag, it should exactly match a version release
ifeq ($(MAKECMDGOALS),release)
	# Use the version number as the release tag.
	DOCKER_TAG = $(CODE_VERSION)

	ifndef CODE_VERSION
$(error You need to create a VERSION file to build a release)
	endif

	# When the value results from complex expansions of variables and functions, expansions you would consider empty may actually contain whitespace characters and thus are not seen as empty. 
	# However, you can use the strip function to avoid interpreting whitespace as a non-empty value. 
	ifeq ($(CODE_VERSION),)
$(error VERSION file not found)
	endif

	# See what commit is tagged to match the version
	# VERSION_COMMIT = $(strip $(shell git rev-list $(CODE_VERSION) -n 1 | cut -c1-7))
	VERSION_COMMIT = $(strip $(shell git rev-list $(CODE_VERSION) -n 1 --abbrev-commit)) #finally...
	# WRONG! VERSION_COMMIT = $(strip $(shell for /f "tokens=7" %f in ('more') do @echo %f))

	ifneq ($(VERSION_COMMIT), $(GIT_COMMIT))
$(error You are trying to push a build based on commit $(GIT_COMMIT) but the tagged release version is $(VERSION_COMMIT))
	endif

	# Don't push to Docker Hub if this isn't a clean repo
	ifneq (x$(GIT_NOT_CLEAN_CHECK), x)
$(error You are trying to release a build based on a dirty repo)
	endif
else

	ifndef CODE_VERSION
$(error You need to create a VERSION file to build a release)
	endif

	# When the value results from complex expansions of variables and functions, expansions you would consider empty may actually contain whitespace characters and thus are not seen as empty. 
	# However, you can use the strip function to avoid interpreting whitespace as a non-empty value. 
	ifeq ($(CODE_VERSION),)
$(error VERSION file not found)
	endif

	# Add the commit ref for development builds. Mark as dirty if the working directory isn't clean
	DOCKER_TAG = $(CODE_VERSION)-$(GIT_COMMIT)$(DOCKER_TAG_SUFFIX)

endif

default: build

# Build Docker image
build: docker_build output

# Build and push Docker image
release: docker_build docker_push output

push:
	$(info Make: Pushing "$(DOCKER_TAG)" tagged image.)
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)

pull:
	$(info Make: Pulling "$(DOCKER_TAG)" tagged image.)
	docker pull $(DOCKER_IMAGE):$(DOCKER_TAG)

restart:
	$(info Make: Restarting "$(DOCKER_TAG)" tagged container.)
	@make -s -f "$(MAKEFILE_JUSTNAME)" stop
	@make -s -f "$(MAKEFILE_JUSTNAME)" run

clean:
	docker system prune --volumes --force

login:
	$(info Make: Login to Docker Hub.)
	docker login -u $(DOCKER_USER) -p $(DOCKER_PASS)

tag:
	$(info Make: Tagging image with "$(DOCKER_TAG)".)
	docker tag $(DOCKER_IMAGE):latest $(DOCKER_IMAGE):$(DOCKER_TAG)

run:
	$(info Make: Starting "$(DOCKER_TAG)" tagged container.)
	docker run -it \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-p 4040:8080 \
	--name $(CONTAINER_NAME) \
	$(DOCKER_IMAGE):$(DOCKER_TAG) 

stop:
	$(info Make: Stopping "$(DOCKER_TAG)" tagged container.)
	docker stop $(CONTAINER_NAME)
	docker rm $(CONTAINER_NAME)

docker_build: Dockerfile
	$(info Make: Building "$(DOCKER_TAG)" tagged images.)
	docker build \
	--build-arg VERSION="$(CODE_VERSION)" \
	--build-arg BUILD_DATE="`echo %date%-%time%`" \
	--build-arg VCS_URL="`git config --get remote.origin.url`" \
	--build-arg VCS_REF="$(GIT_COMMIT)" \
	-t "$(DOCKER_IMAGE):$(DOCKER_TAG)" \
	-f Dockerfile .
	@$(MAKE) --silent -f "$(MAKEFILE_JUSTNAME)" clean

docker_push:
	# Tag image as latest
	docker tag $(DOCKER_IMAGE):$(DOCKER_TAG) $(DOCKER_IMAGE):latest

	# Push to DockerHub
	@make -s -f "$(MAKEFILE_JUSTNAME)" push
	docker push $(DOCKER_IMAGE):latest

output:
	@echo Docker Image: $(DOCKER_IMAGE):$(DOCKER_TAG)