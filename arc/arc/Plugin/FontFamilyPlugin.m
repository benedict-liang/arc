//
//  FontFamilyPlugin.m
//  arc
//
//  Created by Yong Michael on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FontFamilyPlugin.h"


@interface FontFamilyPlugin ()
@property (nonatomic, strong) NSString *defaultFontFamily;

// Dictionary describing fontFamilySetting
@property (nonatomic, strong) NSDictionary *properties;
@end

@implementation FontFamilyPlugin
@synthesize setting = _setting;

- (id)init
{
    if (self = [super init]) {
        _setting = @"fontFamily";
        _defaultFontFamily = @"SourceCodePro-Regular";
        
        // Setup the dictionary to be returned.
        _properties = @{
                        PLUGIN_TITLE: @"Font Family",
                        PLUGIN_TYPE: [NSNumber numberWithInt:kMCQSettingType],
                        PLUGIN_OPTIONS: @[
                                @{
                                    PLUGIN_OPTION_LABEL: @"Source Code Pro",
                                    PLUGIN_OPTION_VALUE: _defaultFontFamily
                                    },
                                @{
                                    PLUGIN_OPTION_LABEL: @"Inconsolata",
                                    PLUGIN_OPTION_VALUE: @"Inconsolata"
                                    },
                                @{
                                    PLUGIN_OPTION_LABEL: @"Ubuntu Monospace",
                                    PLUGIN_OPTION_VALUE: @"UbuntuMono-Regular"
                                    }
                                ]
                        };
    }
    return self;
}

- (BOOL)affectsBounds
{
    return YES;
}

// Returns an NSDictionary of properties for this plugin.
- (NSDictionary *)properties
{
    return _properties;
}

// Returns the default value
- (id<NSObject>)defaultValue
{
    return _defaultFontFamily;
}

- (void)execOnArcAttributedString:(ArcAttributedString *)arcAttributedString
                           ofFile:(id<File>)file
                        forValues:(NSDictionary *)properties
                     sharedObject:(NSMutableDictionary *)dictionary
                         delegate:(id<CodeViewControllerDelegate>)delegate
{
    NSString *fontFamily = [properties objectForKey:_setting];
    [arcAttributedString setFontFamily:fontFamily];
}

- (void)execOnCodeView:(id<CodeViewDelegate>)codeView
                ofFile:(id<File>)file
             forValues:(NSDictionary *)properties
          sharedObject:(NSMutableDictionary *)dictionary
              delegate:(id<CodeViewControllerDelegate>)delegate
{
    NSString *fontFamily = [properties objectForKey:_setting];
    [codeView setFontFamily:fontFamily];
}

- (void)customiseTableViewCell:(UITableViewCell **)cell options:(NSDictionary *)options
{
    // Get the font this cell represents.
    NSString *fontValue = [options valueForKey:PLUGIN_OPTION_VALUE];
    
    UIFont *font = [UIFont fontWithName:fontValue size:[UIFont systemFontSize]];
    [[*cell textLabel] setFont:font];
}


@end
