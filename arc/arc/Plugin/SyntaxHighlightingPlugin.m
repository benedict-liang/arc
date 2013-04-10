//
//  SyntaxHighlightingPlugin.m
//  arc
//
//  Created by Yong Michael on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SyntaxHighlightingPlugin.h"

@interface SyntaxHighlightingPlugin ()
@property (nonatomic, strong) NSString* colorSchemeSettingKey;
// Dictionary describing fontFamilySetting
@property NSMutableDictionary *properties;
@property NSArray *options;
@property NSString *defaultTheme;
@end

@implementation SyntaxHighlightingPlugin
@synthesize settingKeys = _settingKeys;

- (id)init
{
    self = [super init];
    if (self) {
        _colorSchemeSettingKey = @"colorScheme";
        _defaultTheme = @"Monokai.tmTheme";
        _settingKeys = [NSArray arrayWithObject:_colorSchemeSettingKey];
        _theme = [TMBundleThemeHandler produceStylesWithTheme:nil];
        _properties = [NSMutableDictionary dictionary];
        [_properties setValue:@"Color Schemes" forKey:PLUGIN_TITLE];
        
        [_properties setValue:[NSNumber numberWithInt:kMCQSettingType]
                       forKey:PLUGIN_TYPE];
        _options = @[
                     @{
                         PLUGIN_OPTION_LABEL: @"Monokai",
                         PLUGIN_OPTION_VALUE: _defaultTheme
                         },
                     @{
                         PLUGIN_OPTION_LABEL : @"Solarized Light",
                         PLUGIN_OPTION_VALUE: @"Solarized (light).tmTheme"
                         },
                     @{
                         PLUGIN_OPTION_LABEL : @"Solarized Dark",
                         PLUGIN_OPTION_VALUE: @"Solarized (dark).tmTheme"
                         }
                     
                     ];
        
        [_properties setValue:_options forKey:PLUGIN_OPTIONS];
    }
    return self;
}

- (void)execOnArcAttributedString:(ArcAttributedString *)arcAttributedString
                           ofFile:(id<File>)file
                        forValues:(NSDictionary *)properties
                     sharedObject:(NSMutableDictionary *)dictionary
                         delegate:(id)delegate
{
    NSString* themeName = [properties objectForKey:_colorSchemeSettingKey];
    _theme = [TMBundleThemeHandler produceStylesWithTheme:themeName];
    SyntaxHighlight* sh = [[SyntaxHighlight alloc] initWithFile:file del:delegate theme:_theme];
    
    NSDictionary* global = [_theme objectForKey:@"global"];
    UIColor* foreground = [global objectForKey:@"foreground"];
    [arcAttributedString setColor:[foreground CGColor]
                          OnRange:NSMakeRange(0, [(NSString*)[file contents] length])
                       ForSetting:@"syntaxHighlight"];
    
    [dictionary setValue:[_theme objectForKey:@"global"]
                  forKey:@"syntaxHighlightingPlugin"];
    
    if (sh.bundle) {
        ArcAttributedString *copy =
        [[ArcAttributedString alloc] initWithArcAttributedString:arcAttributedString];
        [sh performSelectorInBackground:@selector(execOn:)
                             withObject:copy];
    }
}

- (void)execOnTableView:(UITableView *)tableView
                 ofFile:(id<File>)file
              forValues:(NSDictionary *)properties
           sharedObject:(NSMutableDictionary *)dictionary
               delegate:(id)delegate
{
    NSDictionary *style = [dictionary objectForKey:@"syntaxHighlightingPlugin"];
    tableView.backgroundColor = [style objectForKey:@"background"];
}

- (NSDictionary*)propertiesFor:(NSString *)settingKey
{
    return [NSDictionary dictionaryWithDictionary:_properties];
}

- (id<NSObject>)defaultValueFor:(NSString *)settingKey
{
    if ([settingKey isEqualToString:_colorSchemeSettingKey]) {
        return _defaultTheme;
    }
    return nil;
}
@end
