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
@end

@implementation SyntaxHighlightingPlugin
@synthesize settingKeys = _settingKeys;

- (id)init
{
    self = [super init];
    if (self) {
        _colorSchemeSettingKey = @"colorScheme";
        _settingKeys = [NSArray arrayWithObject:_colorSchemeSettingKey];
        _theme = [TMBundleThemeHandler produceStylesWithTheme:nil];
    }
    return self;
}

- (void)execOnArcAttributedString:(ArcAttributedString *)arcAttributedString
                           ofFile:(id<File>)file
                        forValues:(NSDictionary *)properties
                     sharedObject:(NSMutableDictionary *)dictionary
                         delegate:(id)delegate
{
    SyntaxHighlight* sh = [[SyntaxHighlight alloc] initWithFile:file del:delegate theme:_theme];
    
    NSDictionary* global = [_theme objectForKey:@"global"];
    UIColor* foreground = [global objectForKey:@"foreground"];
    [arcAttributedString setColor:[foreground CGColor]
                          OnRange:NSMakeRange(0, [(NSString*)[file contents] length])
                       ForSetting:@"asdf"];
    
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
    return nil;
}

- (id<NSObject>)defaultValueFor:(NSString *)settingKey
{
    if ([settingKey isEqualToString:_colorSchemeSettingKey]) {
        return @"tmpval";
    }
    return nil;
}
@end
