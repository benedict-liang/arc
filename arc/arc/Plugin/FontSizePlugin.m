//
//  FontSizePlugin.m
//  arc
//
//  Created by Yong Michael on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FontSizePlugin.h"

@interface FontSizePlugin ()
@property (nonatomic) int defaultFontSize;
@property (nonatomic, strong) NSDictionary *properties;
@end

@implementation FontSizePlugin
@synthesize setting = _setting;

- (id)init
{
    self = [super init];
    if (self) {
        _setting = @"fontSize";
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

- (NSDictionary *)properties
{
    return _properties;
}

- (BOOL)affectsBounds
{
    return YES;
}

// Returns the default value for the given setting key.
- (id<NSObject>)defaultValue
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
     [[properties objectForKey:_setting] intValue]];
}

- (void)execOnCodeView:(id<CodeViewDelegate>)codeView
                ofFile:(id<File>)file
             forValues:(NSDictionary *)properties
          sharedObject:(NSMutableDictionary *)dictionary
              delegate:(id<CodeViewControllerDelegate>)delegate
{
    codeView.fontSize = [[properties objectForKey:_setting] intValue];
}

@end
