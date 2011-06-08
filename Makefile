include theos/makefiles/common.mk

TWEAK_NAME = MessageShower
MessageShower_FILES = Tweak.xm
MessageShower_FRAMEWORKS = UIKit Foundation QuartzCore
MessageShower_LDFLAGS = -lactivator

include $(THEOS_MAKE_PATH)/tweak.mk
