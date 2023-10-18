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
#   rm out/test-10.stdout
#   make test-10

GP_PACKAGE_PATH ?= ~/TEE_Initial_Configuration-Test_Suite_v2_0_0_2-2017_06_09.7z

ifeq (,$(GP_PACKAGE_PATH))
ifeq (,$(filter clean,$(MAKECMDGOALS)))
$(error GP_PACKAGE_PATH must point to TEE_Initial_Configuration-Test_Suite_v2_0_0_2-2017_06_09.7z)
endif
endif

all:

.PHONY:
test-image:
	mkdir -p out/test-image
	cp ../common/Dockerfile out/test-image
	cp $(GP_PACKAGE_PATH) out/test-image
	cd out/test-image && \
		docker build $(DOCKER_OPTS) \
			--build-arg USER_ID=$$(id -u) \
			--build-arg USER_GID=$$(id -g) \
			-t optee_qemuv8_test_image .

clean:
	rm -rf out

cleaner: clean
	docker image rm -f optee_qemuv8_test_image

results:
	ls -1 out/*.PASS out/*.SKIPPED

define add-test
test-$(1): out/test-$(1).stdout

.PRECIOUS: out/test-$(1).stdout
out/test-$(1).stdout: | test-image
	docker run -i --rm -v $${HOME}/.cache/ccache:/home/builder/.cache/ccache \
		optee_qemuv8_test_image make -j$$$$(nproc) -C /home/builder/optee/build $(2) check \
		</dev/null >out/test-$(1).stdout 2>out/test-$(1).stderr
	touch out/test-$(1).PASS

all: test-$(1)
endef

define no-add-test
test-$(1): out/test-$(1).SKIPPED

out/test-$(1).SKIPPED:
	touch $$@

all: test-$(1)
endef
