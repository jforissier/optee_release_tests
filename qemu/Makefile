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
$(eval $(call add-test,11,COMPILER=clang))
