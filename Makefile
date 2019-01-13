ARCHS = armv7 arm64
TARGET = iphone:clang:9.0:8.0
#CFLAGS = -fobjc-arc
#THEOS_PACKAGE_DIR_NAME = debs

include theos/makefiles/common.mk

TWEAK_NAME = CustomDock
CustomDock_FILES = Tweak.xm
CustomDock_FRAMEWORKS = UIKit Foundation
CustomDock_LDFLAGS += -Wl,-segalign,4000
CustomDock_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard; killall -9 Preferences"
SUBPROJECTS += CustomDock
include $(THEOS_MAKE_PATH)/aggregate.mk
