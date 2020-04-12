// old iOS 9 SDK #import <Preferences/Preferences.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>
// Modern Preference bundles use these three imports ^^
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CustomDockListController: PSListController {
}
- (void)twitterlink;
- (void)donate;
@end





@implementation CustomDockListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [self loadSpecifiersFromPlistName:@"CustomDock" target:self];
	}
	return _specifiers;
}

- (void)twitterlink {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com/brianvs"]];
} 

- (void)donate
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://paypal.me/i0stweak3r"]];
}


@end

