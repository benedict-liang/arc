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
extern const NSString* DEFAULT_FONT_FAMILY;
extern const CGColorRef* DEFAULT_TEXT_COLOR;

// Default Folder Names
extern const NSString* FOLDER_EXTERNAL_APPLICATIONS;
extern const NSString* FOLDER_ROOT;

// API Keys
extern const NSString* CLOUD_DROPBOX_KEY;
extern const NSString* CLOUD_DROPBOX_SECRET;
@end
