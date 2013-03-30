//
//  DropBoxFolder.m
//  arc
//
//  Created by Jerome Cheng on 30/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "DropBoxFolder.h"

@implementation DropBoxFolder

// Refreshes the contents of this object by reloading them
// from the file system.
// Returns the contents when done.
// DropBoxFolder returns an NSArray of FileObjects contained within it.
- (id)refreshContents
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"Method %@ not implemented in DropBoxFolder.", NSStringFromSelector(_cmd)] userInfo:nil];
}

// Removes this object from the file system.
- (BOOL)remove
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"Method %@ not implemented in DropBoxFolder.", NSStringFromSelector(_cmd)] userInfo:nil];
}

// Renames the folder to the given name.
// Returns YES if successful, NO otherwise.
- (BOOL)rename:(NSString*)name
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"Method %@ not implemented in DropBoxFolder.", NSStringFromSelector(_cmd)] userInfo:nil];
}

// Creates a folder with the given name in this folder.
// Returns YES if successful, NO otherwise.
- (BOOL)createFolder:(NSString *)name
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"Method %@ not implemented in DropBoxFolder.", NSStringFromSelector(_cmd)] userInfo:nil];
}

// Moves a given file to this folder.
// Returns YES if successful, NO otherwise.
- (BOOL)takeFile:(File *)file
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"Method %@ not implemented in DropBoxFolder.", NSStringFromSelector(_cmd)] userInfo:nil];
}

// Looks for a FileObject with the given name within this folder.
// Returns the FileObject if found, nil otherwise.
// NOTE: This runs in O(n) where n is number of objects in the folder.
- (FileObject*)retrieveObjectWithName:(NSString*)name
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"Method %@ not implemented in DropBoxFolder.", NSStringFromSelector(_cmd)] userInfo:nil];
}


@end
