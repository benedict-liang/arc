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
    
    //[global setValue: forKey:@""]
    
    [styles setValue:global forKey:@"global"];
    NSLog(@"%@",styles);
    return styles;
}
@end
