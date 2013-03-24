//
//  FileHelper.h
//  arc
//
//  Created by Jerome Cheng on 24/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "File.h"
#import "Folder.h"
#import "FileObject.h"

@interface FileHelper : NSObject

// Used to handle files passed in from other applications through iOS' "Open in..."
// Moves the file into a folder named after that application (inside External Applications),
// then returns it.
- (File*) fileWithURL:(NSURL*)url sourceApplication:(NSString*)application annotation:(id)annotation;

@end
