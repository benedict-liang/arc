//
//  PluginDelegate.h
//  arc
//
//  Created by Yong Michael on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PluginDelegate <NSObject>
@property (nonatomic, strong) NSArray *settings;
- (NSDictionary *)propertiesFor:(NSString *)setting;
- (id<NSObject>)defaultValueFor:(NSString *)setting;
@end
