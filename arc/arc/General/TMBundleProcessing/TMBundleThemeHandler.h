//
//  TMBundleThemeHandler.h
//  arc
//
//  Created by Benedict Liang on 28/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMBundleThemeHandler : NSObject
//Passed a URL to a tmTheme file.
//Produced a dictionary of the following format
/*
 {
    global : {
        background : UIColor
        ...
    }
    scopes : {
        "comment": {
            "foreground": UIColor
        },
        "string.quoted.double.html" : {
            "foreground": UIColor
        }
    }
 */

+ (NSDictionary*)produceStylesWithTheme:(NSString*)name;

@end
