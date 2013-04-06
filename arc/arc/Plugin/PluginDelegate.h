//
//  PluginDelegate.h
//  arc
//
//  Created by Yong Michael on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PluginDelegate <NSObject>
// Returns an array of NSStrings
// eg: [@"fontFamily", @"fontSize"]
@property (nonatomic, strong) NSArray *settings;

// Returns a NSDictionary of properties for setting
// eg: [pluginInstance propertiesFor:@"fontFamily"]
// returns:
// {
//   type: PluginEnum.MCQ,
//   values: [A, B, C, D]
// }
- (NSDictionary *)propertiesFor:(NSString *)setting;

// Returns Default Value for given setting
- (id<NSObject>)defaultValueFor:(NSString *)setting;
@end
