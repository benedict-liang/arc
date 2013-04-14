//
//  PluginDelegate.h
//  arc
//
//  Created by Yong Michael on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ArcAttributedString.h"
#import "PluginUtilities.h"
#import "File.h"
#import "CodeViewDelegate.h"
@protocol CodeViewControllerDelegate;

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

// Declares if settingKey change requires a recalculation of layout
- (BOOL)settingKeyAffectsBounds:(NSString *)settingKey;

// Returns the default value for the given setting key.
- (id<NSObject>)defaultValueFor:(NSString *)settingKey;

// Exec Methods (Middleware)
// - All Optional, implement as necessary
@optional
- (void)execOnArcAttributedString:(ArcAttributedString *)arcAttributedString
                           ofFile:(id<File>)file
                        forValues:(NSDictionary *)properties
                     sharedObject:(NSMutableDictionary *)dictionary
                         delegate:(id<CodeViewControllerDelegate>)delegate;

@optional
- (void)execOnCodeView:(id<CodeViewDelegate>)codeView
                ofFile:(id<File>)file
             forValues:(NSDictionary *)properties
          sharedObject:(NSMutableDictionary *)dictionary
              delegate:(id<CodeViewControllerDelegate>)delegate;

// Optional method used to allow the plugin
// to customise its Settings Pane cells.
@optional
- (void)customiseTableViewCell:(UITableViewCell **)cell options:(NSDictionary *)options;

@end
