ARCHS = arm64 arm64e armv7 armv7s
TARGET = iphone:clang:11.2:8.0
include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = CustomDock
CustomDock_FILES = CustomDock.mm
CustomDock_INSTALL_PATH = /Library/PreferenceBundles
CustomDock_FRAMEWORKS = UIKit Foundation
CustomDock_PRIVATE_FRAMEWORKS = Preferences
CustomDock_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/CustomDock.plist$(ECHO_END)


// vim:ft=objc
