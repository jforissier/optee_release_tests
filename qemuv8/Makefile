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
	cp Dockerfile out/test-image
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

UTA32 := COMPILE_S_USER=32 CFG_USER_TA_TARGET_pkcs11=ta_arm32

$(eval $(call add-test,01))
$(eval $(call add-test,02,$(UTA32)))
$(eval $(call add-test,03,CFG_WITH_PAGER=y))
$(eval $(call add-test,04,CFG_WITH_PAGER=y $(UTA32)))
$(eval $(call add-test,05,CFG_RPMB_FS=y CFG_RPMB_WRITE_KEY=y))
$(eval $(call add-test,06,CFG_REE_FS=n CFG_RPMB_FS=y CFG_RPMB_WRITE_KEY=y))
$(eval $(call add-test,07,CFG_CORE_DYN_SHM=n))
$(eval $(call add-test,08,CFG_WITH_PAGER=y CFG_RPMB_FS=y CFG_RPMB_WRITE_KEY=y))
$(eval $(call add-test,09,CFG_ULIBS_SHARED=y))
$(eval $(call add-test,10,CFG_ULIBS_SHARED=y CFG_WITH_PAGER=y CFG_CORE_HEAP_SIZE=98304))
$(eval $(call add-test,11,CFG_FTRACE_SUPPORT=y CFG_SYSCALL_FTRACE=y CFLAGS_ta_arm32=-pg CFLAGS_ta_arm64=-pg))
$(eval $(call add-test,12,CFG_CORE_DEBUG_CHECK_STACKS=y CFG_STACK_THREAD_EXTRA=256))
$(eval $(call add-test,13,CFG_LPAE_ADDR_SPACE_BITS=44))
$(eval $(call add-test,14,CFG_LPAE_ADDR_SPACE_BITS=44 $(UTA32)))
$(eval $(call add-test,15,CFG_LPAE_ADDR_SPACE_BITS=44 CFG_WITH_PAGER=y))
$(eval $(call add-test,16,CFG_LPAE_ADDR_SPACE_BITS=44 CFG_WITH_PAGER=y $(UTA32) CFG_CORE_HEAP_SIZE=131072))
$(eval $(call add-test,17,CFG_CORE_PREALLOC_EL0_TBLS=y))
$(eval $(call no-add-test,18,CFG_CORE_BTI=y CFG_TA_BTI=y CFG_USER_TA_TARGETS=ta_arm64 AARCH64_CROSS_COMPILE=/home/builder/x-tools/aarch64-unknown-linux-uclibc/bin/aarch64-unknown-linux-uclibc-)) # regression_1031.4 FAIL
$(eval $(call add-test,19,PAUTH=y))
$(eval $(call add-test,20,MEMTAG=y))
$(eval $(call add-test,21,COMPILER=clang))
$(eval $(call add-test,22,XEN_BOOT=y))
$(eval $(call no-add-test,23,SPMC_AT_EL=2)) # https://github.com/OP-TEE/optee_os/issues/6374
$(eval $(call add-test,24,CFG_CRYPTOLIB_NAME=mbedtls CFG_CRYPTOLIB_DIR=lib/libmbedtls XTEST_ARGS="-x pkcs11_1021 -x pkcs11_1022 -x pkcs11_1023 -x pkcs11_1026"))
