//
//  TMBundleThemeHandler.h
//  arc
//
//  Created by Benedict Liang on 28/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMBundleThemeHandler : NSObject

+ (NSDictionary*)produceStylesWithTheme:(NSURL*)url;

@end
