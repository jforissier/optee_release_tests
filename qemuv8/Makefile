PLAT := qemuv8

include ../common/common.mk

UTA32 := COMPILE_S_USER=32 CFG_USER_TA_TARGET_pkcs11=ta_arm32

$(eval $(call add-test,01,XTEST_ARGS="-l 14"))
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
$(eval $(call skip-test,18,CFG_CORE_BTI=y CFG_TA_BTI=y CFG_USER_TA_TARGETS=ta_arm64 AARCH64_CROSS_COMPILE=/home/builder/x-tools/aarch64-unknown-linux-uclibc/bin/aarch64-unknown-linux-uclibc-)) # regression_1031.4 FAIL
$(eval $(call add-test,19,PAUTH=y))
$(eval $(call add-test,20,MEMTAG=y))
$(eval $(call add-test,21,COMPILER=clang))
$(eval $(call add-test,22,XEN_BOOT=y))
$(eval $(call skip-test,23,SPMC_AT_EL=2)) # https://github.com/OP-TEE/optee_os/issues/6374
$(eval $(call add-test,24,CFG_CRYPTOLIB_NAME=mbedtls CFG_CRYPTOLIB_DIR=lib/libmbedtls XTEST_ARGS="-x pkcs11_1021 -x pkcs11_1022 -x pkcs11_1023 -x pkcs11_1026"))
$(eval $(call add-test,25,CFG_SECSTOR_TA_MGMT_PTA=y CHECK_TESTS=xtest XTEST_ARGS="regression_1008"))
$(eval $(call add-test,26,CFG_CRYPTO_AES_GCM_FROM_CRYPTOLIB=y))
$(eval $(call add-test,27,CFG_CRYPTO_WITH_CE82=y))
$(eval $(call add-test-new-clang,28,COMPILER=clang))
