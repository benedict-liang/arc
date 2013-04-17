//
//  LineNumberPlugin.m
//  arc
//
//  Created by Yong Michael on 11/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "LineNumberPlugin.h"

@interface LineNumberPlugin ()
@property (nonatomic) BOOL defaultSetting;
@property (nonatomic, strong) NSDictionary *properties;
@end

@implementation LineNumberPlugin
@synthesize setting = _setting;

- (id)init
{
    self = [super init];
    if (self) {
        _setting = @"lineNumbers";
        _defaultSetting = YES;
        _properties = @{
                        PLUGIN_TITLE: @"Line Numbers",
                        PLUGIN_TYPE: [NSNumber numberWithInt:kBoolSettingType]
                        };
    }
    return self;
}

- (BOOL)affectsBounds
{
    return YES;
}

- (NSDictionary *)properties
{
    return _properties;
}

// Returns the default value for the given setting key.
- (id<NSObject>)defaultValue
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
    codeView.lineNumbers = [[properties objectForKey:_setting] boolValue];
}

@end

