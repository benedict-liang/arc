//
//  TMBundleThemeHandler.h
//  arc
//
//  Created by Benedict Liang on 28/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface TMBundleThemeHandler : NSObject
//Passed a URL to a tmTheme file.
//Produced a dictionary of the following format
/*
 {
    global = {
        background = 
 */
+ (NSDictionary*)produceStylesWithTheme:(NSURL*)url;

@end
