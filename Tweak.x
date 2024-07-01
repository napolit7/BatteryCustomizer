#import <Foundation/Foundation.h>
#import <Cephei/HBPreferences.h>
#import <UIKit/UIKit.h>
#include <CSColorPicker/CSColorPicker.h>

HBPreferences *preferences = nil;

@interface _UIBatteryView : UIView
- (BOOL)saverModeActive;
- (BOOL)isLowBattery;
- (void)setLowBatteryChargePercentThreshold:(double)arg1;
@end

%hook _UIBatteryView

- (BOOL)isLowBattery {
	[self setLowBatteryChargePercentThreshold:([preferences doubleForKey:@"lowPowerThreshold"]/100)];
	return %orig;
}

- (id)_batteryFillColor {
	if ([preferences boolForKey:@"fillColorSwitch"]) {
		if ([self saverModeActive]) {
			return [UIColor cscp_colorFromHexString:preferences[@"fillColorPowerSaver"]];
		} else if ([self isLowBattery]) {
			return [UIColor cscp_colorFromHexString:preferences[@"fillColorLowPower"]];
		} else {
			return [UIColor cscp_colorFromHexString:preferences[@"fillColor"]];
		}
	}
	return %orig;
}

- (id)boltColor {
	if ([preferences boolForKey:@"boltColorSwitch"]) {
		return [UIColor cscp_colorFromHexString:preferences[@"boltColor"]];
	}
	return [UIColor whiteColor];
}

- (id)bodyColor {
	if ([preferences boolForKey:@"borderColorSwitch"]) {
		return [UIColor cscp_colorFromHexString:preferences[@"borderColor"]];
	}
	return [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4];
}

- (id)pinColor {
	if ([preferences boolForKey:@"pinColorSwitch"]) {
		return [UIColor cscp_colorFromHexString:preferences[@"pinColor"]];
	}
	return [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
}

%end

%ctor {
    preferences = [[HBPreferences alloc] initWithIdentifier:@"com.napolit7.BatteryCustomizerPreferences"];
}