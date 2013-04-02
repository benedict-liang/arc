//
//  Constants.h
//  arc
//
//  Created by Yong Michael on 23/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject
// Sizes
extern const float SIZE_LEFTBAR_WIDTH;
extern const float SIZE_TOOLBAR_HEIGHT;
extern const CGSize SIZE_POPOVER;

// Defaults
extern const int DEFAULT_FONT_SIZE;
extern NSString* const DEFAULT_FONT_FAMILY;
extern const CGColorRef* DEFAULT_TEXT_COLOR;

// App State
extern NSString* const FILE_APP_STATE;
extern NSString* const KEY_CURRENT_FOLDER;
extern NSString* const KEY_CURRENT_FILE;
// Settings
extern NSString* const KEY_SETTINGS_ROOT;
extern NSString* const KEY_FONT_FAMILY;
extern NSString* const KEY_FONT_SIZE;

// Default Folder Names
extern NSString* const FOLDER_EXTERNAL_APPLICATIONS;
extern NSString* const FOLDER_ROOT;
extern NSString* const FOLDER_DROPBOX_ROOT;

// API Keys
extern NSString* const CLOUD_DROPBOX_KEY;
extern NSString* const CLOUD_DROPBOX_SECRET;
@end
