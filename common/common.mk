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
			-t optee_$(PLAT)_test_image -f Dockerfile.$(PLAT) .
	touch $@

clean:
	rm -rf out

cleaner: clean
	docker image rm -f optee_$(PLAT)_test_image

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
	docker run -i --rm -v $${HOME}/.cache/ccache:/home/builder/.cache/ccache \
		-v $$$$(pwd)/out/buildroot_dl:/home/builder/buildroot_dl \
		optee_$(PLAT)_test_image make -j$(NPROC_IN_CONTAINER) -C /home/builder/optee/build $(2) check \
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
