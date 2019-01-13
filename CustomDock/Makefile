ARCHS = armv7 arm64
TARGET = iphone:clang:9.0:8.0
include theos/makefiles/common.mk

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
