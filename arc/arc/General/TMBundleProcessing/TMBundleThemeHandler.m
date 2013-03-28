//
//  TMBundleThemeHandler.m
//  arc
//
//  Created by Benedict Liang on 28/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "TMBundleThemeHandler.h"

@implementation TMBundleThemeHandler

+ (NSDictionary*)produceStylesWithTheme:(NSURL *)url {
    NSURL *testURL = [[NSBundle mainBundle] URLForResource:@"Solarized (light).tmTheme" withExtension:nil];
    NSDictionary* tmTheme = [NSDictionary dictionaryWithContentsOfURL:testURL];
    
    NSArray *settings = [tmTheme objectForKey:@"settings"];
    
    NSMutableDictionary *styles = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *global = [[NSMutableDictionary alloc] initWithDictionary:[(NSDictionary*)[settings objectAtIndex:0] objectForKey:@"settings"]];
    
    NSMutableDictionary *scopes = [[NSMutableDictionary alloc] init];
    
    [styles setValue:global forKey:@"global"];
    
    
    for (int i= 1; i < settings.count; i++) {
        NSDictionary* asetting = [settings objectAtIndex:i];
        NSDictionary* astyle = [asetting objectForKey:@"settings"];
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
    NSLog(@"%@",styles);
    return styles;
}
@end
