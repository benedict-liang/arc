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
        _defaultFontSize = 14;
        _properties = @{
                        PLUGIN_TITLE: @"Font Size",
                        PLUGIN_TYPE: [NSNumber numberWithInt:kRangeSettingType]
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
                         delegate:(id)delegate
{
    [arcAttributedString setFontSize:14];
}
@end
