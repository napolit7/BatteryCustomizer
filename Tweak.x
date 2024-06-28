#import <Foundation/Foundation.h>
#import <Cephei/HBPreferences.h>
#import <UIKit/UIKit.h>
#include <CSColorPicker/CSColorPicker.h>

HBPreferences *preferences = nil;
NSString *c_hex = nil;
BOOL enabled = YES;

%hook _UIBatteryView

- (id)fillColor {
	if (enabled) {
		return [UIColor cscp_colorFromHexString:c_hex];
	}
	return %orig;
}

- (id)_batteryFillColor {
	if (enabled) {
		return [UIColor cscp_colorFromHexString:c_hex];
	}
	return %orig;
}

- (id)boltColor {
	return [UIColor whiteColor];
}

- (id)bodyColor {
	return [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4];
}

- (id)pinColor {
	return [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
}

%end

static void preferencesChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    c_hex = [preferences objectForKey:@"fillColor"];
	enabled = [preferences boolForKey:@"fillColorSwitch"];
}

%ctor {
    preferences = [[HBPreferences alloc] initWithIdentifier:@"com.napolit7.BatteryCustomizerPreferences"];

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)preferencesChanged, CFSTR("com.napolit7.BatteryCustomizerPreferences/ReloadPrefs"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    preferencesChanged(NULL, NULL, NULL, NULL, NULL);
}