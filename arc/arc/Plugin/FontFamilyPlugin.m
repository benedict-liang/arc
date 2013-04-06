//
//  FontFamilyPlugin.m
//  arc
//
//  Created by Yong Michael on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FontFamilyPlugin.h"


@interface FontFamilyPlugin ()
@property NSString *fontFamilySettingKey;
@property NSString *defaultFontFamily;

// Dictionary describing fontFamilySetting
@property NSMutableDictionary *properties;
@property NSArray *options;
@end

@implementation FontFamilyPlugin
@synthesize settingKeys=_settingKeys;

- (id)init
{
    if (self = [super init]) {
        _fontFamilySettingKey = @"fontFamily";
        _defaultFontFamily = @"SourceCodePro-Regular";
        
        _settingKeys = [NSArray arrayWithObject:_fontFamilySettingKey];
        
        // Setup the dictionary to be returned.
        _properties = [NSMutableDictionary dictionary];
        [_properties setValue:@"Font Family"
                       forKey:PLUGIN_TITLE];
        
        [_properties setValue:[NSNumber numberWithInt:kMCQSettingType]
                       forKey:PLUGIN_TYPE];
        
        _options = @[
                     @{
                         PLUGIN_LABEL: @"Source Code Pro",
                         PLUGIN_VALUE: _defaultFontFamily
                         },
                     @{
                         PLUGIN_LABEL: @"Inconsolata",
                         PLUGIN_VALUE: @"Inconsolata"
                         },
                     @{
                         PLUGIN_LABEL: @"Ubuntu Monospace",
                         PLUGIN_VALUE: @"UbuntuMono-Regular"
                         }
                     ];
        
        [_properties setValue:_options forKey:PLUGIN_OPTIONS];
    }
    return self;
}

// Returns an NSDictionary of properties for this plugin.
- (NSDictionary *)propertiesFor:(NSString *)settingKey
{
    return [NSDictionary dictionaryWithDictionary:_properties];
}

// Returns the default value for the given setting key.
- (id<NSObject>)defaultValueFor:(NSString *)settingKey
{
    if ([settingKey isEqualToString:_fontFamilySettingKey]) {
        return _defaultFontFamily;
    }
    
    return nil;
}

- (void)execOnArcAttributedString:(ArcAttributedString *)arcAttributedString
                           ofFile:(id<File>)file
                        forValues:(NSDictionary *)properties
                         delegate:(id)delegate
{
    NSString *fontFamily = [properties objectForKey:_fontFamilySettingKey];
    [arcAttributedString setFontFamily:fontFamily];
}


@end
