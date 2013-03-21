//
//  Folder.h
//  arc
//
//  Created by Jerome Cheng on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FileObject.h"
#import "File.h"

@interface Folder : FileObject

// Creates a folder with the given name inside this folder.
// Returns YES if successful, NO otherwise.
- (BOOL)addFolder:(NSString*)folderName;

// Adds the given file to this folder.
// Returns YES if successful, NO otherwise.
- (BOOL)addFile:(File*)file;


@end
