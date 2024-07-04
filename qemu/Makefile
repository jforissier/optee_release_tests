PLAT := qemu

include ../common/common.mk

$(eval $(call add-test,01))
$(eval $(call add-test,02,CFG_WITH_PAGER=y))
$(eval $(call add-test,03,CFG_WITH_PAGER=y CFG_WITH_LPAE=n))
$(eval $(call add-test,04,CFG_RPMB_FS=y CFG_RPMB_WRITE_KEY=y))
$(eval $(call add-test,05,CFG_REE_FS=n CFG_RPMB_FS=y CFG_RPMB_WRITE_KEY=y))
$(eval $(call add-test,06,CFG_CORE_DYN_SHM=n))
$(eval $(call add-test,07,CFG_WITH_PAGER=y CFG_RPMB_FS=y CFG_RPMB_WRITE_KEY=y CFG_CORE_HEAP_SIZE=98304))
$(eval $(call add-test,08,CFG_ULIBS_SHARED=y))
$(eval $(call add-test,09,CFG_ULIBS_SHARED=y CFG_WITH_PAGER=y))
$(eval $(call add-test,10,CFG_FTRACE_SUPPORT=y CFLAGS_ta_arm32=-pg CFLAGS_ta_arm64=-pg))
$(eval $(call add-test-clang,11,COMPILER=clang))
$(eval $(call add-test,12,CFG_CRYPTOLIB_NAME=mbedtls CFG_CRYPTOLIB_DIR=lib/libmbedtls XTEST_ARGS="-x pkcs11_1021 -x pkcs11_1026"))
$(eval $(call add-test,13,CFG_TEE_CORE_LOG_LEVEL=0 CFG_LOCKDEP=y CFG_LOCKDEP_RECORD_STACK=n CFG_IN_TREE_EARLY_TAS=pkcs11/fd02c9da-306c-48c7-a49c-bbd827ae86ee CFG_PKCS11_TA=y)) # same config as the "QEMUv7 check" CI job: https://github.com/OP-TEE/optee_os/blob/4.2.0/.github/workflows/ci.yml#L274
