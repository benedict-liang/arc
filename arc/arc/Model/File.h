//
//  File.h
//  arc
//
//  Created by Jerome Cheng on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FileObject.h"

@class Folder;

@interface File : FileObject

// Creates a file with the given name and contents, in the given folder.
// Returns a reference to the file.
+ (id)fileWithName:(NSString*)name Contents:(NSString*)contents inFolder:(Folder*)folder;

@end
