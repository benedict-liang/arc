//
//  FontFamilyPlugin.m
//  arc
//
//  Created by Yong Michael on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FontFamilyPlugin.h"

@interface FontFamilyPlugin ()
// Array containing the dictionaries corresponding to each setting key.
@property NSArray *_propertyDictionaries;

// Array containing the default values corresponding to each setting key.
@property NSArray *_defaultValues;
@end

@implementation FontFamilyPlugin

// Synthesize protocol properties.
@synthesize settingKeys=_settingKeys;

- (id)init
{
    if (self = [super init]) {
        _settingKeys = [NSArray arrayWithObject:@"fontFamily"];
        
        // Setup the dictionary to be returned.
        NSMutableDictionary *properties = [[NSMutableDictionary alloc] init];
        [properties setValue:@"Font Family" forKey:PLUGIN_TITLE];
        [properties setValue:[NSNumber numberWithInt:kMCQSettingType] forKey:PLUGIN_TYPE];
        [properties setValue:[NSArray arrayWithObjects:@"Inconsolata", @"Source Code Pro", "Ubuntu Monospace", nil] forKey:PLUGIN_LABELS];
        [properties setValue:[NSArray arrayWithObjects:@"Inconsolata", @"SourceCodePro-Regular", @"UbuntuMono-Regular", nil] forKey:PLUGIN_VALUES];
        __propertyDictionaries = [NSArray arrayWithObject:properties];
        
        // Setup the default values.
        __defaultValues = [NSArray arrayWithObject:@"SourceCodePro-Regular"];
    }
    return self;
}

// Returns an NSDictionary of properties for this plugin.
- (NSDictionary *)propertiesFor:(NSString *)settingKey
{
    int dictionaryIndex = [_settingKeys indexOfObject:settingKey];
    return [__propertyDictionaries objectAtIndex:dictionaryIndex];
}

// Returns the default value for the given setting key.
- (id<NSObject>)defaultValueFor:(NSString *)settingKey
{
    int dictionaryIndex = [_settingKeys indexOfObject:settingKey];
    return [__defaultValues objectAtIndex:dictionaryIndex];
}

@end
