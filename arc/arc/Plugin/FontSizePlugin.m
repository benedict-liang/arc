//
//  FontSizePlugin.m
//  arc
//
//  Created by Yong Michael on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FontSizePlugin.h"

@implementation FontSizePlugin
@synthesize settingKeys = _settingKeys;

- (NSDictionary *)propertiesFor:(NSString *)settingKey
{
    
}

// Returns the default value for the given setting key.
- (id<NSObject>)defaultValueFor:(NSString *)settingKey
{
    return [NSNumber numberWithInt:14];
}

// Exec Method (Middleware)
- (void)arcAttributedString:(ArcAttributedString*)arcAttributedString
                     ofFile:(id<File>)file
                   delegate:(id)delegate
{
//        [arcAttributedString setFontSize:fontSize];
}
@end
