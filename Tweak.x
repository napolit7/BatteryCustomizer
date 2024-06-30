#import <Foundation/Foundation.h>
#import <Cephei/HBPreferences.h>
#import <UIKit/UIKit.h>
#include <CSColorPicker/CSColorPicker.h>

HBPreferences *preferences = nil;
NSDictionary *cached_prefs = nil;

@interface _UIBatteryView : UIView
- (BOOL)saverModeActive;
- (BOOL)isLowBattery;
@end

%hook _UIBatteryView

- (id)fillColor {
	if (cached_prefs[@"fillColorSwitch"]) {
		if ([self saverModeActive]) {
			return [UIColor cscp_colorFromHexString:cached_prefs[@"fillColorPowerSaver"]];
		} else {
			return [UIColor cscp_colorFromHexString:cached_prefs[@"fillColor"]];
		}
	}
	return %orig;
}

- (id)_batteryFillColor {
	if (cached_prefs[@"fillColorSwitch"]) {
		if ([self saverModeActive]) {
			return [UIColor cscp_colorFromHexString:cached_prefs[@"fillColorPowerSaver"]];
		} else {
			return [UIColor cscp_colorFromHexString:cached_prefs[@"fillColor"]];
		}
	}
	return %orig;
}

- (id)boltColor {
	if (cached_prefs[@"boltColorSwitch"]) {
		return [UIColor cscp_colorFromHexString:cached_prefs[@"boltColor"]];
	}
	return [UIColor whiteColor];
}

- (id)bodyColor {
	if (cached_prefs[@"borderColorSwitch"]) {
		return [UIColor cscp_colorFromHexString:cached_prefs[@"borderColor"]];
	}
	return [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4];
}

- (id)pinColor {
	if (cached_prefs[@"pinColorSwitch"]) {
		return [UIColor cscp_colorFromHexString:cached_prefs[@"pinColor"]];
	}
	return [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
}

%end

static void preferencesChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    cached_prefs = [preferences dictionaryRepresentation];
}

%ctor {
    preferences = [[HBPreferences alloc] initWithIdentifier:@"com.napolit7.BatteryCustomizerPreferences"];

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)preferencesChanged, CFSTR("com.napolit7.BatteryCustomizerPreferences/ReloadPrefs"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    preferencesChanged(NULL, NULL, NULL, NULL, NULL);
}