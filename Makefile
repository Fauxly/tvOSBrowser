export THEOS_PACKAGE_SCHEME=rootless

include $(THEOS)/makefiles/common.mk

PACKAGE_VERSION=1.0

include $(THEOS_MAKE_PATH)/aggregate.mk
