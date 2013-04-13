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
const float SIZE_TOOLBAR_ICON_WIDTH = 30;
// Defaults
const CGColorRef* DEFAULT_TEXT_COLOR = {0};

// App State
NSString* const FILE_APP_STATE = @"appState.plist";
NSString* const KEY_CURRENT_FOLDER = @"currentFolder";
NSString* const KEY_CURRENT_FILE = @"currentFile";
NSString* const KEY_FONTS = @"Fonts";

// Settings
NSString* const KEY_SETTINGS_ROOT = @"Settings";
NSString* const KEY_FONT_FAMILY = @"fontFamily";
NSString* const KEY_FONT_SIZE = @"fontSize";
NSString* const KEY_LINE_NUMBERS = @"lineNumbers";
NSString* const KEY_WORD_WRAP = @"wordWrap";

// Default Folder Names
NSString* const FOLDER_EXTERNAL_APPLICATIONS = @"External Applications";
NSString* const FOLDER_ROOT = @"Documents";
NSString* const FOLDER_DROPBOX_ROOT = @"DropBox";

// API Keys
NSString* const CLOUD_DROPBOX_KEY = @"q591oqy8n4yxgt1";
NSString* const CLOUD_DROPBOX_SECRET = @"kkb1vzgnah76zmr";
NSString* const CLOUD_SKYDRIVE_KEY = @"00000000480F0B47";
NSString* const CLOUD_SKYDRIVE_SECRET = @"LJv3JNgZK037xFdLrDFwHnFRWb-TJFN1";

// SkyDrive scopes
NSString* const SKYDRIVE_SCOPE_SIGNIN = @"wl.signin";
NSString* const SKYDRIVE_SCOPE_READ_ACCESS = @"wl.skydrive";

// Syntaxes File List
NSString* const SYNTAXES_FILE_LIST = @"syntaxesFileList.txt";

// Bundle Conf
NSString* const BUNDLE_CONF = @"BundleConf.plist";

// Tabs
const int TAB_DROPBOX = 0;
const int TAB_DOCUMENTS = 1;
const int TAB_SETTINGS = 2;

@implementation Constants
@end
