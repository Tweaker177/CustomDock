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

//Set alpha for the dock
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

//Changing dock height instead of its offscreen fraction- has an effect on icon placement/ bounds.
//Only using it in portrait orientation since it could be vertical or horizontal depending on tweaks used.

%hook SBDockView 
-(CGFloat)dockHeight {
if(!kEnabled) return %orig;
//return original value if tweak is off before taking up memory for variables and checks
screenHeight= [[UIScreen mainScreen]bounds].size.height;
screenWidth = [[UIScreen mainScreen]bounds].size.width;

if(kDockHeightEnabled && (screenHeight>screenWidth)) {
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
//Default is off so no need to use objectForKey
kdockPercent= [[prefs objectForKey:@"dockPercent"] doubleValue];
//default here is zero so no need to check if there's a value first;
kopacityVal = [[prefs objectForKey:@"opacityVal"] doubleValue] ? [[prefs objectForKey:@"opacityVal"] doubleValue] : 100.f;
//Makes sure default is 100

kDockHeightEnabled = [prefs boolForKey:@"dockHeightEnabled"];
//Default is @NO so no need to use objectForKey

kDockHeight = [[prefs objectForKey:@"dockHeight"] floatValue] ? [[prefs objectForKey:@"dockHeight"]floatValue] : 96.f;
 Check if a value has been set and use 96 as the default if the slider hasn't been moved yet.
}

%ctor {
    CFNotificationCenterAddObserver(
                                    CFNotificationCenterGetDarwinNotifyCenter(), NULL,
                                    (CFNotificationCallback)loadPrefs,
                                    CFSTR("com.i0stweak3r.customdock/settingschanged"), NULL,
                                    CFNotificationSuspensionBehaviorDeliverImmediately);
    loadPrefs();
}


