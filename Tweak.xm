/*%%%%%
%% Tweak.xm
%% MessageShower
%%
%% Created by theiostream on his early coding days.
%% He is not proud of it.
%% WTFPLv3-licensed.
%%%%%*/

/*%%
% Imports/Macros
%%*/

#include <objc/runtime.h>
#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import <libactivator.h>

#define MH_PLIST_PATH "/var/mobile/Library/Preferences/am.theiostre.messageshowersettings.plist"

/*%%
% Interface declarations
%%*/

@interface SBAlertItem : NSObject
@end

@interface SBUserNotificationAlert : SBAlertItem
- (void)setAlertHeader:(NSString *)header;
- (void)setAlertMessage:(NSString *)msg;
- (void)setDefaultButtonTitle:(NSString *)title;
@end

@interface SBAlertItemsController : NSObject
+ (id)sharedInstance;
- (void)activateAlertItem:(SBAlertItem *)item;
@end

@interface MHActivator : NSObject <LAListener>
@end

/*%%
% Globals
%%*/

static BOOL iconEnabled = NO;
static BOOL actiEnabled = NO;
static NSString *title = nil;
static NSString *message = nil;

/*%%
% Preference Helpers
%%*/

static BOOL MHGetBoolPref(NSDictionary *dict, NSString *key, BOOL def) {
	NSNumber *v = [dict objectForKey:key];
	return v ? [v boolValue] : def;
}

static void MHUpdatePrefs() {
	if (title != nil) { [title release]; title = nil; }
	if (message != nil) { [message release]; message = nil; }
	
	NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:@MH_PLIST_PATH];
	if (!plist) return;

	iconEnabled = MHGetBoolPref(plist, @"AppStart", YES);
	actiEnabled = MHGetBoolPref(plist, @"ActivatorEnabled", YES);
	
	NSString *_title = [plist objectForKey:@"AppStartTitle"];
	title = _title ? [_title retain] : @"MessageShower";
	
	NSString *_message = [plist objectForKey:@"AppStartMessage"];
	message = _message ? [_message retain] : @"Get to Settings and change this placeholder message!";
}

static void MHReloadPrefs(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
	MHUpdatePrefs();
}

/*%%
% Functions
%%*/

static void MHAlert() {
	SBUserNotificationAlert *alert = [[%c(SBUserNotificationAlert) alloc] init];
	[alert setAlertHeader:title];
	[alert setAlertMessage:message];
	[alert setDefaultButtonTitle:@"I get it."];
	
	[(SBAlertItemsController *)[%c(SBAlertItemsController) sharedInstance] activateAlertItem:alert];
	[alert release];
}

/*%%
% Hooks
%%*/

@implementation MHActivator
- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {	
	if (actiEnabled)
		MHAlert();
	
	[event setHandled:YES];
}

+ (void)load {
	[[LAActivator sharedInstance] registerListener:[self new] forName:@"am.theiostre.messageshower"];
}
@end

%hook SBApplicationIcon
- (void)launch {
	if (iconEnabled)
		MHAlert();
	
	%orig;
}
%end

%ctor {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	%init;
	
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, &MHReloadPrefs, CFSTR("am.theiostre.messageshower.updated"), NULL, CFNotificationSuspensionBehaviorHold);
	MHUpdatePrefs();
	
	[pool drain];
}