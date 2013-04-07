//
//  PluginUtilities.h
//  arc
//
//  Created by Jerome Cheng on 7/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PluginUtilities : NSObject

// Plugin Dictionary Keys
extern NSString* const PLUGIN_TITLE;
extern NSString* const PLUGIN_TYPE;
extern NSString* const PLUGIN_OPTIONS;
extern NSString* const PLUGIN_LABEL;
extern NSString* const PLUGIN_VALUE;
extern NSString* const PLUGIN_RANGE_MIN;
extern NSString* const PLUGIN_RANGE_MAX;

// Settings Pane Section Properties
extern NSString* const SECTION_SETTING_KEY;
extern NSString* const SECTION_HEADING;
extern NSString* const SECTION_TYPE;
extern NSString* const SECTION_OPTIONS;

@end
