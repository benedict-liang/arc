//
//  Folder.h
//  arc
//
//  Created by Jerome Cheng on 1/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileSystemObject.h"
@protocol Folder <FileSystemObject>

@optional
// Moves the given FileSystemObject to this Folder.
// The given file must be of the same "type" as this Folder
// (e.g. iOS file system, DropBox, etc.)
// Returns YES if successful, NO otherwise.
- (BOOL)takeFileSystemObject:(id<FileSystemObject>)target;

// Returns the FileSystemObject with the given name.
// Will return nil if the object is not found.
- (id<FileSystemObject>)retrieveItemWithName:(NSString *)name;

// Creates a Folder with the given name inside this one.
// Returns the created Folder object.
- (id<Folder>)createFolderWithName:(NSString *)name;

// Renames this Folder to the given name.
// Returns YES if successful, NO otherwise.
- (BOOL)rename:(NSString *)name;

// Given a FileSystemObject path, searches for and returns the object
// at that path.
- (id<FileSystemObject>)objectAtPath:(NSString *)path;
@end
