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

const int SIZE_CODEVIEW_PADDING_AROUND = 20;
const int SIZE_CODEVIEW_MARGIN_LINENUMBERS = 5;
const int SIZE_CODEVIEW_LINENUMBERS_MIN = 30;
const int SIZE_CODEVIEW_PADDING_LINENUMBERS = 10;

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

//Code VC keys
NSString* const KEY_RANGE = @"range";
NSString* const KEY_LINE_NUMBER = @"lineNumber";
NSString* const KEY_LINE_START = @"lineStart";

// Values
const int THRESHOLD_LONG_SETTING_LIST = 5;

// Default Folder Names
NSString* const FOLDER_EXTERNAL_APPLICATIONS = @"External Applications";
NSString* const FOLDER_ROOT = @"Documents";
NSString* const FOLDER_DROPBOX_ROOT = @"Dropbox";

// SkyDrive scopes
NSString* const SKYDRIVE_SCOPE_SIGNIN = @"wl.signin";
NSString* const SKYDRIVE_SCOPE_READ_ACCESS = @"wl.skydrive";
NSString* const SKYDRIVE_SCOPE_OFFLINE = @"wl.offline_access";
// SkyDrive Strings
NSString* const SKYDRIVE_STRING_ROOT_FOLDER = @"me/skydrive";
NSString* const SKYDRIVE_STRING_FILE_CONTENTS = @"/content";
NSString* const SKYDRIVE_STRING_FOLDER_CONTENTS = @"/files";

// Google Drive variables
NSString* const GOOGLE_KEYCHAIN_NAME = @"arc";

// Cloud Constants
const int CLOUD_MAX_CONCURRENT_DOWNLOADS = 10;

// Syntaxes File List
NSString* const SYNTAXES_FILE_LIST = @"syntaxesFileList.txt";

// Bundle Conf
NSString* const BUNDLE_CONF = @"BundleConf.plist";

// Tabs
const int TAB_DROPBOX = 0;
const int TAB_DOCUMENTS = 1;
const int TAB_SETTINGS = 2;

NSString* const DEFAULT_FILE = @"arc.md";
@implementation Constants
+ (NSArray *)privilegedFileList
{
    return @[@"appState.plist",DEFAULT_FILE];
}
+(NSArray*)syntaxOverlays {
    return @[@"comment",@"string"];
}
@end
