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
    NSArray *allPaths = [fileManager contentsOfDirectoryAtPath:[_url path] error:nil];
    NSMutableArray *folderObjects = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *fileObjects = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSString *currentName in allPaths) {
        NSString *escapedName = [currentName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *currentURL = [[NSURL alloc] initWithString:escapedName relativeToURL:_url];
        
        // We already know the file exists, but we need to figure out if
        // it's a file or folder.
        BOOL isCurrentDirectory;
        [fileManager fileExistsAtPath:[currentURL path] isDirectory:&isCurrentDirectory];
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
    NSError *error;
    BOOL isRemovalSuccessful = [fileManager removeItemAtURL:_url error:&error];
    if (isRemovalSuccessful) {
        [[self parent] flagForRefresh];
    } else {
        NSLog(@"%@", error);
    }
    return isRemovalSuccessful;
}

// Renames the folder to the given name.
// Returns YES if successful, NO otherwise.
- (BOOL)rename:(NSString*)name
{
    NSString *parentPath = [[self parent] path];
    NSString *newPath = [[parentPath stringByAppendingPathComponent:name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *newURL = [NSURL URLWithString:newPath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL isRenameSuccessful = [fileManager moveItemAtURL:_url toURL:newURL error:&error];
    if (isRenameSuccessful) {
        [[self parent] flagForRefresh];
    } else {
        NSLog(@"%@", error);
    }
    return isRenameSuccessful;
}

// Creates a folder with the given name in this folder.
// Returns YES if successful, NO otherwise.
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
    
    NSError *error;
    BOOL isCreateSuccessful = [fileManager createDirectoryAtURL:newFolderURL withIntermediateDirectories:YES attributes:nil error:&error];
    if (isCreateSuccessful) {
        [self flagForRefresh];
    } else {
        NSLog(@"%@", error);
    }
    return isCreateSuccessful;
}

// Moves a given file to this folder.
// Returns YES if successful, NO otherwise.
- (BOOL)takeFile:(File *)file
{
    
}

@end
