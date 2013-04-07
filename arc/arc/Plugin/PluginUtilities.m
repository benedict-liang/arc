//
//  PluginUtilities.m
//  arc
//
//  Created by Jerome Cheng on 7/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "PluginUtilities.h"

@implementation PluginUtilities

// Plugin Dictionary Keys
NSString* const PLUGIN_TITLE = @"title";
NSString* const PLUGIN_TYPE = @"type";
NSString* const PLUGIN_OPTIONS = @"options";
NSString* const PLUGIN_OPTION_LABEL = @"label";
NSString* const PLUGIN_OPTION_VALUE = @"value";
NSString* const PLUGIN_OPTION_RANGE_MIN = @"min";
NSString* const PLUGIN_OPTION_RANGE_MAX = @"max";

// Settings Pane Section Properties
NSString* const SECTION_PLUGIN_OBJECT = @"sectionPlugin";
NSString* const SECTION_SETTING_KEY = @"sectionSettingKey";
NSString* const SECTION_HEADING = @"sectionHeading";
NSString* const SECTION_TYPE = @"sectionType";
NSString* const SECTION_OPTIONS = @"sectionOptions";

// Casts a kSettingType into an NSNumber, suitable for
// saving into a dictionary.
+ (NSNumber *)numberForSettingType:(kSettingType)enumValue
{
    return [NSNumber numberWithInt:enumValue];
}

// Takes an NSNumber and turns it back into a kSettingType.
+ (kSettingType)settingTypeForNumber:(NSNumber *)number
{
    return [number intValue];
}

@end
