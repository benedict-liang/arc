//
//  PluginDelegate.h
//  arc
//
//  Created by Yong Michael on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcAttributedString.h"
#import "File.h"

typedef enum {
    kMCQSettingType,
    kRangeSettingType,
    kBoolSettingType
} kSettingType;

@protocol PluginDelegate <NSObject>
// Returns an array of NSStrings
// eg: [@"fontFamily", @"fontSize"]
@property (nonatomic, strong) NSArray *settingKeys;

// Returns a NSDictionary of properties for setting
// eg: [pluginInstance propertiesFor:@"fontFamily"]
// returns:
// {
//   type: kMCQSettingType,
//   values: [A, B, C, D]
// }
- (NSDictionary *)propertiesFor:(NSString *)settingKey;

// Returns Default Value for given setting
- (id<NSObject>)defaultValueFor:(NSString *)settingKey;

// Exec Method (Middleware)
+ (void)arcAttributedString:(ArcAttributedString*)arcAttributedString
                     ofFile:(id<File>)file
                   delegate:(id)delegate;
@end
