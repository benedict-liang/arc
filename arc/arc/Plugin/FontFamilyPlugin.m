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

// Array containing the dictionaries corresponding to each setting key.
@property NSArray *propertyDictionaries;

// Array containing the default values corresponding to each setting key.
@property NSArray *defaultValues;
@end

@implementation FontFamilyPlugin

// Synthesize protocol properties.
@synthesize settingKeys=_settingKeys;

- (id)init
{
    if (self = [super init]) {
        _fontFamilySettingKey = @"fontFamily";
        _defaultFontFamily = @"SourceCodePro-Regular";

        _settingKeys = [NSArray arrayWithObject:_fontFamilySettingKey];
        
        // Setup the dictionary to be returned.
        NSMutableDictionary *properties = [NSMutableDictionary dictionary];
        [properties setValue:@"Font Family"
                      forKey:PLUGIN_TITLE];

        [properties setValue:[NSNumber numberWithInt:kMCQSettingType]
                      forKey:PLUGIN_TYPE];

        [properties setValue:[NSArray arrayWithObjects:
                              _defaultFontFamily,
                              @"Inconsolata",
                              @"Ubuntu Monospace",
                              nil]
                      forKey:PLUGIN_LABELS];

        [properties setValue:[NSArray arrayWithObjects:
                              @"Inconsolata",
                              @"SourceCodePro-Regular",
                              @"UbuntuMono-Regular",
                              nil]
                      forKey:PLUGIN_VALUES];

        _propertyDictionaries = [NSArray arrayWithObject:properties];
    }
    return self;
}

// Returns an NSDictionary of properties for this plugin.
- (NSDictionary *)propertiesFor:(NSString *)settingKey
{
    int dictionaryIndex = [_settingKeys indexOfObject:settingKey];
    return [_propertyDictionaries objectAtIndex:dictionaryIndex];
}

// Returns the default value for the given setting key.
- (id<NSObject>)defaultValueFor:(NSString *)settingKey
{
    int dictionaryIndex = [_settingKeys indexOfObject:settingKey];
    return [_defaultValues objectAtIndex:dictionaryIndex];
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
