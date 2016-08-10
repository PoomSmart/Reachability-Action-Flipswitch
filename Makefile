DEBUG = 0
TARGET = iphone:latest:8.0
PACKAGE_VERSION = 0.0.2

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = ReachabilityActionSwitch
ReachabilityActionSwitch_FILES = Settings.m Switch.xm
ReachabilityActionSwitch_LIBRARIES = flipswitch substrate
ReachabilityActionSwitch_INSTALL_PATH = /Library/Switches

include $(THEOS_MAKE_PATH)/bundle.mk