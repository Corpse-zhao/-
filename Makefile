ARCHS = arm64e
TARGET = iphone:clang:16.6:16.6
INSTALL_TARGET_PROCESSES = SpringBoard
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk
TWEAK_NAME = PixelHeart

PixelHeart_FILES = Tweak.x SettingView.m
PixelHeart_CFLAGS = -fobjc-arc
PixelHeart_FRAMEWORKS = UIKit QuartzCore

include $(THEOS)/makefiles/tweak.mk
