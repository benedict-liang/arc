//
//  Constants.m
//  arc
//
//  Created by Yong Michael on 23/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "Constants.h"

// Sizes
const float SIZE_LEFTBAR_WIDTH = 200;
const float SIZE_TOOLBAR_HEIGHT = 44;
const CGSize SIZE_POPOVER = {200,300};

// Defaults
const int DEFAULT_FONT_SIZE = 12;
NSString* const DEFAULT_FONT_FAMILY = @"SourceCodePro-Regular";
const CGColorRef* DEFAULT_TEXT_COLOR = {0};

// App State
NSString* const FILE_APP_STATE = @"appState.plist";
NSString* const KEY_CURRENT_FOLDER = @"currentFolder";
NSString* const KEY_CURRENT_FILE = @"currentFile";
// Settings
NSString* const KEY_SETTINGS_ROOT = @"Settings";
NSString* const KEY_FONT_FAMILY = @"fontFamily";
NSString* const KEY_FONT_SIZE = @"fontSize";

// Default Folder Names
NSString* const FOLDER_EXTERNAL_APPLICATIONS = @"External Applications";
NSString* const FOLDER_ROOT = @"Documents";
NSString* const FOLDER_DROPBOX_ROOT = @"DropBox";

// API Keys
NSString* const CLOUD_DROPBOX_KEY = @"q591oqy8n4yxgt1";
NSString* const CLOUD_DROPBOX_SECRET = @"kkb1vzgnah76zmr";

@implementation Constants
@end
