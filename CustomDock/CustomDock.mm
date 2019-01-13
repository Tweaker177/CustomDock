#import <Preferences/Preferences.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CustomDockListController: PSListController {
}
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

