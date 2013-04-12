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
        _properties = [NSMutableDictionary dictionary];
        [_properties setValue:@"Color Schemes" forKey:PLUGIN_TITLE];
        
        [_properties setValue:[NSNumber numberWithInt:kMCQSettingType]
                       forKey:PLUGIN_TYPE];
        
        _options = [SyntaxHighlightingPlugin generateOptions];

        
        [_properties setValue:_options forKey:PLUGIN_OPTIONS];
        
        _cache = [NSMutableDictionary dictionary];
    }
    return self;
}
+ (NSArray*)generateOptions {
    NSURL* themeConf = [[NSBundle mainBundle] URLForResource:@"ThemeConf.plist" withExtension:nil];
    NSDictionary* themes = [NSDictionary dictionaryWithContentsOfURL:themeConf];
    NSMutableArray* opts = [NSMutableArray array];
    for (NSString* themeName in themes) {
        NSString* themeFile = [themes objectForKey:themeName];
        [opts addObject:@{PLUGIN_OPTION_LABEL:themeName,
                        PLUGIN_OPTION_VALUE:themeFile}];
        
    }
    
    [opts sortUsingComparator:(NSComparator)^(id k1, id k2){
        NSString* s1 = [(NSDictionary*) k1 objectForKey:PLUGIN_OPTION_LABEL];
        NSString* s2 = [(NSDictionary*) k2 objectForKey:PLUGIN_OPTION_LABEL];
        return [s1 compare:s2];
    }];
    return opts;
}

- (void)execOnArcAttributedString:(ArcAttributedString *)arcAttributedString
                           ofFile:(id<File>)file
                        forValues:(NSDictionary *)properties
                     sharedObject:(NSMutableDictionary *)dictionary
                         delegate:(id<CodeViewControllerDelegate>)delegate
{
    NSString* themeName = [properties objectForKey:_colorSchemeSettingKey];
    
    NSDictionary* themeDictionary = [TMBundleThemeHandler produceStylesWithTheme:themeName];
    NSDictionary* global = [themeDictionary objectForKey:@"global"];
    
    [arcAttributedString setForegroundColor:[global objectForKey:@"foreground"]
                                    OnRange:arcAttributedString.stringRange
                                 ForSetting:@"foreground"];
    
    
    [dictionary setValue:[themeDictionary objectForKey:@"global"]
                  forKey:@"syntaxHighlightingPlugin"];
    
    SyntaxHighlight* cachedHighlighter = [_cache objectForKey:[file path]];
    
    if (cachedHighlighter) {
        
        NSDictionary *syntaxOpts = @{
        @"theme":themeName,
        @"attributedString":[[ArcAttributedString alloc] initWithArcAttributedString:arcAttributedString]
        };
        
        [cachedHighlighter performSelectorInBackground:@selector(reapplyWithOpts:) withObject:syntaxOpts];
        
    } else {
        SyntaxHighlight* sh = [[SyntaxHighlight alloc] initWithFile:file del:delegate];
        
        if (sh.bundle) {
            ArcAttributedString *copy =
            [[ArcAttributedString alloc] initWithArcAttributedString:arcAttributedString];
            NSDictionary* syntaxOptions = @{
                                            @"theme":themeName,
                                            @"attributedString":copy
                                            };
            
            [sh performSelectorInBackground:@selector(execOn:)
                                 withObject:syntaxOptions];
            
            [_cache setObject:sh forKey:[file path]];
        }
    }

}

- (void)execOnCodeView:(id<CodeViewDelegate>)codeView
                ofFile:(id<File>)file
             forValues:(NSDictionary *)properties
          sharedObject:(NSMutableDictionary *)dictionary
              delegate:(id<CodeViewControllerDelegate>)delegate
{
    NSDictionary *style = [dictionary objectForKey:@"syntaxHighlightingPlugin"];
    codeView.backgroundColor = [style objectForKey:@"background"];
    codeView.foregroundColor = [style objectForKey:@"foreground"];
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
