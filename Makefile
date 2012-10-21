include theos/makefiles/common.mk

TWEAK_NAME = MessageShower
MessageShower_FILES = Tweak.xm
MessageShower_FRAMEWORKS = UIKit
MessageShower_LDFLAGS = -lactivator

include $(THEOS_MAKE_PATH)/tweak.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp Resources/MHPreferences.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/MessageShower.plist$(ECHO_END)
	
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/Activator/Listeners/am.theiostre.messageshower$(ECHO_END)
	$(ECHO_NOTHING)cp Resources/MHActivator.plist $(THEOS_STAGING_DIR)/Library/Activator/Listeners/am.theiostre.messageshower/Info.plist$(ECHO_END)