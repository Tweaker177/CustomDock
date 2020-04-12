ARCHS = arm64 arm64e armv7 armv7s
TARGET = iphone:clang:11.2:8.0
#CFLAGS = -fobjc-arc
#THEOS_PACKAGE_DIR_NAME = debs
GO_EASY_ON_ME = 1
DEBUG = 0
include $(THEOS)/makefiles/common.mk

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
