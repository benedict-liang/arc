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
@property NSDictionary *properties;
@property NSString *defaultTheme;
@property NSMutableArray *threadPool;
@end

@implementation SyntaxHighlightingPlugin
@synthesize settingKeys = _settingKeys;
@synthesize delegate = _delegate;
@synthesize cache = _cache;

- (id)init
{
    self = [super init];
    if (self) {
        _colorSchemeSettingKey = @"colorScheme";
        _defaultTheme = @"Monokai.tmTheme";
        _settingKeys = [NSArray arrayWithObject:_colorSchemeSettingKey];
        _properties = @{
                        PLUGIN_TITLE: @"Color Schemes",
                        PLUGIN_TYPE: [NSNumber numberWithInt:kMCQSettingType],
                        PLUGIN_OPTIONS:[SyntaxHighlightingPlugin generateOptions]
                        };
        _threadPool = [NSMutableArray array];

        _cache = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (NSArray*)generateOptions {
    NSURL* themeConf = [[NSBundle mainBundle] URLForResource:@"ThemeConf.plist"
                                               withExtension:nil];
    NSDictionary* themes = [NSDictionary dictionaryWithContentsOfURL:themeConf];
    NSMutableArray* opts = [NSMutableArray array];
    for (NSString* themeName in themes) {
        NSString* themeFile = [themes objectForKey:themeName];
        [opts addObject:
         @{
            PLUGIN_OPTION_LABEL:themeName,
            PLUGIN_OPTION_VALUE:themeFile
         }];
        
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
    
    // Set Foreground color
    [arcAttributedString removeAttributesForSettingKey:@"foreground"];
    [arcAttributedString setForegroundColor:[global objectForKey:@"foreground"]
                                    OnRange:arcAttributedString.stringRange
                                 ForSetting:@"foreground"];


    [dictionary setValue:[themeDictionary objectForKey:@"global"]
                  forKey:@"syntaxHighlightingPlugin"];
    
    
    // Kill all thread pool
    for (SyntaxHighlight *thread in _threadPool) {
        [thread kill];
    }
    [_threadPool removeAllObjects];

    SyntaxHighlight* sh = [_cache objectForKey:[file path]];
    if (!sh) {
        sh = [[SyntaxHighlight alloc] initWithFile:file
                                       andDelegate:delegate];

        // give sh object a reference to the factory
        // to enable it to remove itself from the thread pool
        sh.factory = self;

        // add to cache
        [_cache setObject:sh forKey:[file path]];
    }
    
    if (sh.bundle) {
        // add object to the thread pool
        [_threadPool addObject:sh];
        
        ArcAttributedString *copy =
        [[ArcAttributedString alloc] initWithArcAttributedString:arcAttributedString];
        
        NSDictionary* syntaxOptions = @{
                                        @"theme":themeDictionary,
                                        @"attributedString":copy
                                        };

        [sh performSelectorInBackground:@selector(execOn:)
                             withObject:syntaxOptions];
    }
}

- (void)removeFromThreadPool:(SyntaxHighlight *)sh
{
    [_threadPool removeObject:sh];
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

- (BOOL)settingKeyAffectsBounds:(NSString *)settingKey
{
    if ([settingKey isEqualToString:_colorSchemeSettingKey]) {
        return NO;
    }
    return NO;
}

- (NSDictionary*)propertiesFor:(NSString *)settingKey
{
    if ([settingKey isEqualToString:_colorSchemeSettingKey]) {
        return [NSDictionary dictionaryWithDictionary:_properties];
    }
    return nil;
}

- (id<NSObject>)defaultValueFor:(NSString *)settingKey
{
    if ([settingKey isEqualToString:_colorSchemeSettingKey]) {
        return _defaultTheme;
    }
    return nil;
}
@end
