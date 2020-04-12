#include <stdlib.h>
#include <substrate.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/* not needed since switching to defaults 
#define PLIST_PATH              
@"private/var/mobile/Library/Preferences/com.i0stweak3r.customdock.plist"
*/

static bool kEnabled= YES;
static double kdockPercent;
static double kopacityVal;
static double trans;
static float dockheightfrac;
static CGFloat kDockHeight;
static bool kDockHeightEnabled;


%hook SBRootFolderView
-(void)_setDockOffscreenFraction:(double)arg1 {
if(!kEnabled) {
    return %orig;
}
dockheightfrac= kdockPercent / 100;
arg1= dockheightfrac;
return %orig(arg1);
}


-(void)_applyDockOffscreenFraction:(CGFloat)arg1 {
if(!kEnabled)
    {
    return %orig;
}
dockheightfrac= kdockPercent / 100;
arg1= dockheightfrac;
return %orig(arg1);
}

%end

%hook SBDockView
-(void) setBackgroundAlpha:(double)arg1 {

  if(!kEnabled)

{  
return %orig;
}
trans= kopacityVal/100;

arg1= trans;
return %orig(arg1);
}
%end


%hook SBDockView 
-(CGFloat)dockHeight {
screenHeight= [[UIScreen mainScreen]bounds].size.height;
screenWidth = [[UIScreen mainScreen]bounds].size.width;
//Changing dock height instead of its offscreen fraction- has an effect on icon placement/ bounds.
//Only using it in portrait orientation since it could be vertical or horizontal depending on tweaks used.
if(kEnabled && kDockHeightEnabled &&(screenHeight>screenWidth)) {
return kDockHeight;
}
else { return %orig; }
}
%end


static void
loadPrefs() {
    static NSUserDefaults *prefs = [[NSUserDefaults alloc]
                                    initWithSuiteName:@"com.i0stweak3r.customdock"];
    
    kEnabled = [prefs boolForKey:@"Enabled"];

kdockPercent= [[prefs objectForKey:@"dockPercent"] doubleValue];

kopacityVal = [[prefs objectForKey:@"opacityVal"] doubleValue];

kDockHeightEnabled = [prefs boolForKey:@"dockHeightEnabled"];

kDockHeight = [[prefs objectForKey:@"dockHeight"] floatValue] ? [[prefs objectForKey:@"dockHeight"]floatValue] : 96.f;
 
}

%ctor {
    CFNotificationCenterAddObserver(
                                    CFNotificationCenterGetDarwinNotifyCenter(), NULL,
                                    (CFNotificationCallback)loadPrefs,
                                    CFSTR("com.i0stweak3r.customdock/settingschanged"), NULL,
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
    loadPrefs();
}


