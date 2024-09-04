# Usage:
#
# - Build and run all tests, check which one passed. On a BIG system, -j10 or
#   more can be used.
#
#   make
#   ls out/*.PASS
#
# - Clean so make will rebuild everything (except the build container image):
#
#   make clean
#
# - Clean everything including build container image:
#
#   make cleaner
#
# - Re-build and re-run only test configuration number 10:
#
#   rm out/test-10.log
#   make test-10

GP_PACKAGE_PATH ?= ~/TEE_Initial_Configuration-Test_Suite_v2_0_0_2-2017_06_09.7z

DOCKER_OPTS ?= --no-cache

ifeq (,$(GP_PACKAGE_PATH))
ifeq (,$(filter clean,$(MAKECMDGOALS)))
$(error GP_PACKAGE_PATH must point to TEE_Initial_Configuration-Test_Suite_v2_0_0_2-2017_06_09.7z)
endif
endif

ifeq (,$(PLAT))
$(error PLAT is undefined or empty)
endif

all:

.PHONY:
test-image: out/.test-image

out/.test-image:
	mkdir -p out/test-image
	cp ../common/Dockerfile.base ../common/Dockerfile.$(PLAT) out/test-image
	cp $(GP_PACKAGE_PATH) out/test-image
	cd out/test-image && \
		docker build $(DOCKER_OPTS) \
			--build-arg USER_ID=$$(id -u) \
			--build-arg USER_GID=$$(id -g) \
			--build-arg HOST_DOCKER_GID=$$(stat -c %g /var/run/docker.sock 2>/dev/null || echo 0) \
			-t optee_$(PLAT)_test_image -f Dockerfile.$(PLAT) .
	touch $@

# Clean test logs and result to be able to run them again
clean:
	rm -rf out/test-*.*

# clean + also remove Docker image
cleaner: clean
	rm -rf out/.test-image out/test_image
	docker image rm -f optee_$(PLAT)_test_image

# cleaner + remove source packages downloaded by Buildroot
distclean: cleaner
	rm -rf out/buildroot_dl

results:
	RES=$$(ls out/*.PASS out/*.SKIPPED 2>/dev/null); echo $${RES} | sort | tr ' ' '\n'

NPROC_IN_CONTAINER ?= $$$$(nproc)

all-tests:
	$(MAKE) -j$(nproc) all NPROC_IN_CONTAINER=1 CONTAINER_FLAGS="BR2_PER_PACKAGE_DIRECTORIES=n"

define add-test
test-$(1): out/test-$(1).log

.PRECIOUS: out/test-$(1).log
out/test-$(1).log: out/.test-image
	mkdir -p $$(CURDIR)/out/buildroot_dl
	docker run -i --rm -v /var/run/docker.sock:/var/run/docker.sock \
		-v $${HOME}/.cache/ccache:/home/builder/.cache/ccache \
		-v $$$$(pwd)/out/buildroot_dl:/home/builder/buildroot_dl \
		optee_$(PLAT)_test_image make -j$(NPROC_IN_CONTAINER) -C /home/builder/optee/build $(2) check \
		$(CONTAINER_FLAGS) \
		</dev/null 2>&1 >out/test-$(1).log
	touch out/test-$(1).PASS

all: test-$(1)
endef

define add-test-new-clang
test-$(1): out/test-$(1).log

.PRECIOUS: out/test-$(1).log
out/test-$(1).log: out/.test-image
	mkdir -p $$(CURDIR)/out/buildroot_dl
	docker run -i --rm -v /var/run/docker.sock:/var/run/docker.sock \
		-v $${HOME}/.cache/ccache:/home/builder/.cache/ccache \
		-v $$$$(pwd)/out/buildroot_dl:/home/builder/buildroot_dl \
		optee_$(PLAT)_test_image /bin/bash -c 'make -j$(NPROC_IN_CONTAINER) -C /home/builder/optee/build clang-toolchains-build && make -j$(NPROC_IN_CONTAINER) -C /home/builder/optee/build $(2) check' \
		$(CONTAINER_FLAGS) \
		</dev/null 2>&1 >out/test-$(1).log
	touch out/test-$(1).PASS

all: test-$(1)
endef


define skip-test
test-$(1): out/test-$(1).SKIPPED

out/test-$(1).SKIPPED:
	mkdir -p out
	touch $$@

all: test-$(1)
endef
