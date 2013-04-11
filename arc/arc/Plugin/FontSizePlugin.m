//
//  FontSizePlugin.m
//  arc
//
//  Created by Yong Michael on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FontSizePlugin.h"

@interface FontSizePlugin ()
@property (nonatomic, strong) NSString* fontSizeSettingsKey;
@property (nonatomic) int defaultFontSize;
@property (nonatomic, strong) NSDictionary *properties;
@end

@implementation FontSizePlugin
@synthesize settingKeys = _settingKeys;

- (id)init
{
    self = [super init];
    if (self) {
        _fontSizeSettingsKey = @"fontSize";
        _settingKeys = [NSArray arrayWithObject:_fontSizeSettingsKey];
        _defaultFontSize = 14;
        _properties = @{
                        PLUGIN_TITLE: @"Font Size",
                        PLUGIN_TYPE: [NSNumber numberWithInt:kRangeSettingType],
                        PLUGIN_OPTION_RANGE_MIN: [NSNumber numberWithInt:10],
                        PLUGIN_OPTION_RANGE_MAX: [NSNumber numberWithInt:70]
                        };
    }
    return self;
}

- (NSDictionary *)propertiesFor:(NSString *)settingKey
{
    if ([settingKey isEqualToString:_fontSizeSettingsKey]) {
        return _properties;
    }
    return nil;
}

// Returns the default value for the given setting key.
- (id<NSObject>)defaultValueFor:(NSString *)settingKey
{
    return [NSNumber numberWithInt:_defaultFontSize];
}

- (void)execOnArcAttributedString:(ArcAttributedString *)arcAttributedString
                           ofFile:(id<File>)file
                        forValues:(NSDictionary *)properties
                     sharedObject:(NSMutableDictionary *)dictionary
                         delegate:(id<CodeViewControllerDelegate>)delegate
{
    [arcAttributedString setFontSize:
     [[properties objectForKey:_fontSizeSettingsKey] intValue]];
}
@end
