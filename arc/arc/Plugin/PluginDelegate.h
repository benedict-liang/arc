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
// Returns the setting key this plugin uses.
// eg: @"fontFamily"
@property (nonatomic, strong) NSString *setting;

// Returns an NSDictionary of properties for this plugin.
// eg: [pluginInstance properties]
// returns:
// {
//   title: "Font Family",
//   type: kMCQSettingType,
//   labels: ["Inconsolata", "Source Code Pro", "Ubuntu Monospace"],
//   values: ["Inconsolata", "SourceCodePro-Regular", "Ubuntu Mono Regular"]
// }
- (NSDictionary *)properties;

// Declares if plugin change requires a recalculation of layout
- (BOOL)affectsBounds;

// Returns the default value for the plugin
- (id<NSObject>)defaultValue;

// Exec Methods (Middleware)
// - All Optional, implement as necessary
@optional
- (void)execPreRenderOnArcAttributedString:(ArcAttributedString *)arcAttributedString
                                  CodeView:(id<CodeViewDelegate>)codeView
                                    ofFile:(id<File>)file
                                 forValues:(NSDictionary *)properties
                              sharedObject:(NSMutableDictionary *)dictionary
                                  delegate:(id<CodeViewControllerDelegate>)delegate;

@optional
- (void)execPostRenderOnCodeView:(id<CodeViewDelegate>)codeView
                          ofFile:(id<File>)file
                       forValues:(NSDictionary *)properties
                    sharedObject:(NSMutableDictionary *)dictionary
                        delegate:(id<CodeViewControllerDelegate>)delegate;

// Optional method used to allow the plugin
// to customise its Settings Pane cells.
@optional
- (void)customiseTableViewCell:(UITableViewCell **)cell options:(NSDictionary *)options;

@end
