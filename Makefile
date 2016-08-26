# Copyright (c) 2016 by Eugene Ciurana, pr3d4t0r, CIME Software Ltd.
#
# vim: set fileencoding=utf-8:
#
# See:  LICENSE for complete licensing information.


DOCKER_ENABLED=$(shell which docker; echo $$?)

docker_check:
ifeq ($(DOCKER_ENABLED), 1)
	@printf "cannot built target '%s' - docker not available or not running\n\n" $@
	@exit 1
endif
ifndef IMAGE
    # GitHub and Docker Hub -- identical names.
    override IMAGE=pr3d4t0r/sabre.io
endif


all:
	@make image
	@make push


install:
	@make push


image: docker_check
	docker build -t $(IMAGE) --rm=true .


push: docker_check
	docker push $(IMAGE)


run: docker_check
	docker run --rm --name="sabre.io" -h "sabre.io" -p "8000:8000" -v $(shell pwd):"/var/www/html" $(IMAGE)

