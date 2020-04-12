#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/* not needed since switching to defaults 
#define PLIST_PATH              
@"private/var/mobile/Library/Preferences/com.i0stweak3r.customdock.plist"
*/

const CGFloat firmware =  [[UIDevice currentDevice].systemVersion floatValue];
//Simple way to detect firmware



static bool kEnabled= YES;
static double kdockPercent;
static double kOpacityVal;
static double trans;
static float dockheightfrac;
static CGFloat kDockHeight;
static bool kDockHeightEnabled;


%hook SBRootFolderView
//Several updated methods for iOS 13

-(UIEdgeInsets)_statusBarInsetsForDockEdge:(unsigned long long)arg1 dockOffscreenPercentage:(double)arg2 {
    if(kEnabled && (firmware >= 13.0)) {
        dockheightfrac= kdockPercent / 100;
        arg2= dockheightfrac;
        return %orig(arg1,arg2);
    }
    return %orig;
}

-(double)currentDockOffscreenFraction {
    if(kEnabled && (firmware >=13.0)) {
        dockheightfrac= kdockPercent / 100;
        return dockheightfrac;
    }
    return %orig;
}



-(void)setDockOffscreenFraction:(double)arg1 {

if(kEnabled) {

dockheightfrac= kdockPercent / 100;
arg1= dockheightfrac;
return %orig(arg1);
}
return %orig;
}


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
trans= kOpacityVal/100;

arg1= trans;
return %orig(arg1);
}
%end

//NEW IOS 13 CLASS ACTUALLY A PROTOCOL
%hook SBDockOffscreenFractionModifying
-(void)setDockOffscreenFraction:(double)arg1 {
if(kEnabled && (firmware >= 13.0)) {
    dockheightfrac= kdockPercent / 100;
    arg1= dockheightfrac;
    return %orig(arg1);
}
return %orig;
}
%end


//Changing dock height instead of its offscreen fraction- has an effect on icon placement/ blur bounds.
//Only using it in portrait orientation since it could be vertical or horizontal depending on tweaks used.

%hook SBDockView 
-(CGFloat)dockHeight {
if(!kEnabled || !kDockHeightEnabled) return %orig;
//return original value if tweak is off before taking up memory for variables and checks
CGFloat screenHeight= [[UIScreen mainScreen]bounds].size.height;
CGFloat screenWidth = [[UIScreen mainScreen]bounds].size.width;

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
kOpacityVal = [[prefs objectForKey:@"opacityVal"] doubleValue] ? [[prefs objectForKey:@"opacityVal"] doubleValue] : 100.f;
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


