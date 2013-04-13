//
//  LineNumberPlugin.m
//  arc
//
//  Created by Yong Michael on 11/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "LineNumberPlugin.h"

@interface LineNumberPlugin ()
@property (nonatomic, strong) NSString* lineNumberSettingsKey;
@property (nonatomic) BOOL defaultSetting;
@property (nonatomic, strong) NSDictionary *properties;
@end

@implementation LineNumberPlugin
@synthesize settingKeys = _settingKeys;

- (id)init
{
    self = [super init];
    if (self) {
        _lineNumberSettingsKey = @"lineNumbers";
        _settingKeys = [NSArray arrayWithObject:_lineNumberSettingsKey];
        _defaultSetting = YES;
        _properties = @{
                        PLUGIN_TITLE: @"Line Numbers",
                        PLUGIN_TYPE: [NSNumber numberWithInt:kBoolSettingType]
                        };
    }
    return self;
}

- (NSDictionary *)propertiesFor:(NSString *)settingKey
{
    if ([settingKey isEqualToString:_lineNumberSettingsKey]) {
        return _properties;
    }
    return nil;
}

// Returns the default value for the given setting key.
- (id<NSObject>)defaultValueFor:(NSString *)settingKey
{
    return [NSNumber numberWithBool:_defaultSetting];
}

//- (void)execOnArcAttributedString:(ArcAttributedString *)arcAttributedString
//                           ofFile:(id<File>)file
//                        forValues:(NSDictionary *)properties
//                     sharedObject:(NSMutableDictionary *)dictionary
//                         delegate:(id<CodeViewControllerDelegate>)delegate
//{
//
//}

- (void)execOnCodeView:(id<CodeViewDelegate>)codeView
                ofFile:(id<File>)file
             forValues:(NSDictionary *)properties
          sharedObject:(NSMutableDictionary *)dictionary
              delegate:(id<CodeViewControllerDelegate>)delegate
{
    codeView.lineNumbers = [[properties objectForKey:_lineNumberSettingsKey] boolValue];
}

@end

