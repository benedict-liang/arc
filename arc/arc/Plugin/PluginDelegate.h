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
// Returns an array of NSStrings corresponding to the
// settings keys this plugin uses.
// eg: [@"fontFamily", @"fontSize"]
@property (nonatomic, strong) NSArray *settingKeys;

// Returns an NSDictionary of properties for this plugin.
// eg: [pluginInstance propertiesFor:@"fontFamily"]
// returns:
// {
//   title: "Font Family",
//   type: kMCQSettingType,
//   labels: ["Inconsolata", "Source Code Pro", "Ubuntu Monospace"],
//   values: ["Inconsolata", "SourceCodePro-Regular", "Ubuntu Mono Regular"]
// }
- (NSDictionary *)propertiesFor:(NSString *)settingKey;

// Returns the default value for the given setting key.
- (id<NSObject>)defaultValueFor:(NSString *)settingKey;

// Exec Method (Middleware)
+ (void)arcAttributedString:(ArcAttributedString*)arcAttributedString
                     ofFile:(id<File>)file
                   delegate:(id)delegate;
@end
