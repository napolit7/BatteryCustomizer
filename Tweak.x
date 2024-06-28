#import <Foundation/Foundation.h>
#import <Cephei/HBPreferences.h>
#import <UIKit/UIKit.h>
#include <CSColorPicker/CSColorPicker.h>

HBPreferences *preferences = nil;
NSString *fill_hex = nil;
BOOL fill_enabled = NO;
NSString *bolt_hex = nil;
BOOL bolt_enabled = NO;
NSString *pin_hex = nil;
BOOL pin_enabled = NO;
NSString *border_hex = nil;
BOOL border_enabled = NO;

%hook _UIBatteryView

- (id)fillColor {
	if (fill_enabled) {
		return [UIColor cscp_colorFromHexString:fill_hex];
	}
	return %orig;
}

- (id)_batteryFillColor {
	if (fill_enabled) {
		return [UIColor cscp_colorFromHexString:fill_hex];
	}
	return %orig;
}

- (id)boltColor {
	if (bolt_enabled) {
		return [UIColor cscp_colorFromHexString:bolt_hex];
	}
	return [UIColor whiteColor];
}

- (id)bodyColor {
	if (border_enabled) {
		return [UIColor cscp_colorFromHexString:border_hex];
	}
	return [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4];
}

- (id)pinColor {
	if (pin_enabled) {
		return [UIColor cscp_colorFromHexString:pin_hex];
	}
	return [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
}

%end

static void preferencesChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    fill_hex = [preferences objectForKey:@"fillColor"];
	fill_enabled = [preferences boolForKey:@"fillColorSwitch"];
	bolt_hex = [preferences objectForKey:@"boltColor"];
	bolt_enabled = [preferences boolForKey:@"boltColorSwitch"];
	pin_hex = [preferences objectForKey:@"pinColor"];
	pin_enabled = [preferences boolForKey:@"pinColorSwitch"];
	border_hex = [preferences objectForKey:@"borderColor"];
	border_enabled = [preferences boolForKey:@"borderColorSwitch"];
}

%ctor {
    preferences = [[HBPreferences alloc] initWithIdentifier:@"com.napolit7.BatteryCustomizerPreferences"];

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)preferencesChanged, CFSTR("com.napolit7.BatteryCustomizerPreferences/ReloadPrefs"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    preferencesChanged(NULL, NULL, NULL, NULL, NULL);
}