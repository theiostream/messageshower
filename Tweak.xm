#include <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "libactivator/libactivator.h"

#define PLIST_PATH @"/var/mobile/Library/Preferences/am.theiostre.messageshowersettings.plist"

//AppKill

%hook SBApplicationIcon

- (void)launch {
NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:PLIST_PATH];
  if ([[dict objectForKey:@"AppStart"] boolValue]) {
  UIAlertView* text = [[UIAlertView alloc] init];
  text.title = [dict objectForKey:@"AppStartTitle"];
  text.message = [dict objectForKey:@"AppStartMessage"];
  [text addButtonWithTitle:@"I get it."];
  [text show];
  
  }
%orig;
}

%end

%hook SBScreenFlash
- (void)flash {
  NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:PLIST_PATH];
  if ([[dict objectForKey:@"FlashStart"] boolValue]) {
  UIAlertView* text = [[UIAlertView alloc] init];
  text.title = [dict objectForKey:@"FlashStartTitle"];
  text.message = [dict objectForKey:@"FlashStartMessage"];
  [text addButtonWithTitle:@"I get it."];
  [text show];
  %orig;
}
  if ([[dict objectForKey:@"FlashKill"] boolValue]) {
  UIAlertView* text = [[UIAlertView alloc] init];
  text.title = [dict objectForKey:@"FlashKillTitle"];
  text.message = [dict objectForKey:@"FlashKillMessage"];
  [text addButtonWithTitle:@"I get it."];
  [text show];
}

}
%end

//ActivatorSupport
@interface Shower : NSObject<LAListener> {}
@end

@implementation Shower

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event
{
  NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:PLIST_PATH];
  UIAlertView* text = [[UIAlertView alloc] init];
  text.title = [dict objectForKey:@"Title"];
  text.message = [dict objectForKey:@"Message"];
  [text addButtonWithTitle:@"I get it."];
  [text show];
  [event setHandled:YES];
}

+ (void)load
{
  [[LAActivator sharedInstance] registerListener:[self new]forName:@"am.theiostre.messageshower"];
}

@end