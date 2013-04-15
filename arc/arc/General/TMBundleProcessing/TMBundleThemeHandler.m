//
//  TMBundleThemeHandler.m
//  arc
//
//  Created by Benedict Liang on 28/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "TMBundleThemeHandler.h"

@implementation TMBundleThemeHandler

+ (NSDictionary*)produceStylesWithTheme:(NSString*)name
{
    //TODO manage theme selection
    NSURL *testURL = [[NSBundle mainBundle] URLForResource:name withExtension:nil];
    NSDictionary* tmTheme = [NSDictionary dictionaryWithContentsOfURL:testURL];
    
    NSArray *settings = [tmTheme objectForKey:@"settings"];
    
    NSMutableDictionary *styles = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *global = [[NSMutableDictionary alloc] initWithDictionary:[(NSDictionary*)[settings objectAtIndex:0] objectForKey:@"settings"]];
    
    global = [NSMutableDictionary dictionaryWithDictionary:[TMBundleThemeHandler mapHexStrToUIColor:global]];
    
    NSMutableDictionary *scopes = [[NSMutableDictionary alloc] init];
    
    [styles setValue:global forKey:@"global"];
    
    for (int i= 1; i < settings.count; i++) {
        NSDictionary* asetting = [settings objectAtIndex:i];
        NSDictionary* astyle = [asetting objectForKey:@"settings"];
        astyle = [TMBundleThemeHandler filterEmptyStringVals:astyle];
        astyle = [TMBundleThemeHandler mapHexStrToUIColor:astyle];
        NSString* scopeString = [asetting objectForKey:@"scope"];
        if (scopeString) {
            NSArray* scopeStrings = [scopeString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@", "]];
            for (NSString *ascope in scopeStrings) {
                if (![ascope isEqualToString:@""]) {
                    [scopes setValue:astyle forKey:ascope];
                }
            }
        }
    }
    [styles setValue:scopes forKey:@"scopes"];

    return styles;
}

+ (NSDictionary*)filterEmptyStringVals:(NSDictionary*)dict
{
    NSMutableDictionary* res = [[NSMutableDictionary alloc] init];
    for (id k in dict) {
        NSString *v = [dict objectForKey:k];
        if (![v isEqualToString:@""]) {
            [res setValue:v forKey:k];
        }
    }
    return res;
}

//maps "#FDF5E3" to UIColor. only applies to keys specified in colorKeys
+ (NSDictionary*)mapHexStrToUIColor:(NSDictionary*)dict
{
    NSArray *colorKeys = @[@"foreground", @"background"];
    NSMutableDictionary* res = [[NSMutableDictionary alloc] init];
    for (NSString *k in dict) {
        if ([colorKeys containsObject:k]) {
            NSString *hexStr = [dict objectForKey:k];
            [res setValue:[Utils colorWithHexString:hexStr]
                   forKey:k];
        } else {
            [res setValue:[dict objectForKey:k] forKey:k];
        }
    }
    return res;
}
@end
