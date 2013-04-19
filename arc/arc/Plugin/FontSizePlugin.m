//
//  FontSizePlugin.m
//  arc
//
//  Created by Yong Michael on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FontSizePlugin.h"

@interface FontSizePlugin ()
@property (nonatomic) NSString *defaultFontSize;
@property (nonatomic, strong) NSDictionary *properties;
@end

@implementation FontSizePlugin
@synthesize setting = _setting;

- (id)init
{
    self = [super init];
    if (self) {
        _setting = @"fontSize";
        _defaultFontSize = @"18";
        // Setup the dictionary to be returned.
        _properties = @{
                        PLUGIN_TITLE: @"Font Size",
                        PLUGIN_TYPE: [NSNumber numberWithInt:kMCQSettingType],
                        PLUGIN_OPTIONS: @[
                                @{
                                    PLUGIN_OPTION_LABEL: @"Smallest",
                                    PLUGIN_OPTION_VALUE: @"10"
                                    },

                                @{
                                    PLUGIN_OPTION_LABEL: @"Tiny",
                                    PLUGIN_OPTION_VALUE: @"12"
                                    },
                                @{
                                    PLUGIN_OPTION_LABEL: @"Smaller",
                                    PLUGIN_OPTION_VALUE: @"14"
                                    },
                                @{
                                    PLUGIN_OPTION_LABEL: @"Small",
                                    PLUGIN_OPTION_VALUE: @"16"
                                    },
                                @{
                                    PLUGIN_OPTION_LABEL: @"Medium",
                                    PLUGIN_OPTION_VALUE: _defaultFontSize
                                    },
                                @{
                                    PLUGIN_OPTION_LABEL: @"Large",
                                    PLUGIN_OPTION_VALUE: @"22"
                                    },
                                @{
                                    PLUGIN_OPTION_LABEL: @"Larger",
                                    PLUGIN_OPTION_VALUE: @"28"
                                    },
                                @{
                                    PLUGIN_OPTION_LABEL: @"Giant",
                                    PLUGIN_OPTION_VALUE: @"35"
                                    },
                                @{
                                    PLUGIN_OPTION_LABEL: @"Largest",
                                    PLUGIN_OPTION_VALUE: @"40"
                                    }
                                ]
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
    return _defaultFontSize;
}

- (void)execPreRenderOnArcAttributedString:(ArcAttributedString *)arcAttributedString
                                  CodeView:(id<CodeViewDelegate>)codeView
                                    ofFile:(id<File>)file
                                 forValues:(NSDictionary *)properties
                              sharedObject:(NSMutableDictionary *)dictionary
                                  delegate:(id<CodeViewControllerDelegate>)delegate
{
    [arcAttributedString setFontSize:
     [[properties objectForKey:_setting] intValue]];
    
    codeView.fontSize = [[properties objectForKey:_setting] intValue];
}

@end
