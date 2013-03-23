//
//  Folder.m
//  arc
//
//  Created by Jerome Cheng on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "Folder.h"

@implementation Folder

// Refreshes the contents of this object by reloading them
// from the file system.
// Returns the contents when done.
// Folder returns an NSArray of FileObjects contained within it.
- (id)refreshContents
{
    // Load the contents of this folder.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *allPaths = [fileManager contentsOfDirectoryAtPath:[self path] error:nil];
    NSMutableArray *folderObjects = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *fileObjects = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSString *currentPath in allPaths) {
        NSURL *currentURL = [[NSURL alloc] initWithString:currentPath];
        BOOL isCurrentDirectory;
        
        // We don't need to check that the file actually exists,
        // since we wouldn't have its path if it didn't. We just need
        // to see if it's a directory.
        [fileManager fileExistsAtPath:currentPath isDirectory:&isCurrentDirectory];
        if (isCurrentDirectory) {
            Folder *currentFolder = [[Folder alloc] initWithURL:currentURL parent:self];
            [folderObjects addObject:currentFolder];
        } else {
            File *currentFile = [[File alloc] initWithURL:currentURL parent:self];
            [fileObjects addObject:currentFile];
        }
    }
    
    [folderObjects addObjectsFromArray:fileObjects];
    _contents = folderObjects;
    _needsRefresh = NO;
    return folderObjects;
}

// Removes this object from the file system.
- (BOOL)remove
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isRemovalSuccessful = [fileManager removeItemAtURL:_url error:nil];
    if (isRemovalSuccessful) {
        [[self parent] flagForRefresh];
    }
    return isRemovalSuccessful;
}

// Renames the folder to the given name.
// Returns YES if successful, NO otherwise.
- (BOOL)rename:(NSString*)name
{
    NSString *parentPath = [[[self parent] path] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *newPath = [parentPath stringByAppendingPathComponent:name];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isRenameSuccessful = [fileManager moveItemAtPath:[self path] toPath:newPath error:nil];
    if (isRenameSuccessful) {
        [[self parent] flagForRefresh];
    }
    return isRenameSuccessful;
}

- (BOOL)createFolder:(NSString *)name
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Replace all spaces in the string with %20.
    NSString *escapedName = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // Add a / to the end, if necessary.
    NSString *formattedName;
    if ([escapedName hasSuffix:@"/"]) {
        formattedName = escapedName;
    } else {
        formattedName = [escapedName stringByAppendingString:@"/"];
    }
    
    NSURL *newFolderURL = [NSURL URLWithString:formattedName relativeToURL:_url];
    
    BOOL isCreateSuccessful = [fileManager createDirectoryAtURL:newFolderURL withIntermediateDirectories:YES attributes:nil error:nil];
    if (isCreateSuccessful) {
        [self flagForRefresh];
    }
    return isCreateSuccessful;
}

@end
