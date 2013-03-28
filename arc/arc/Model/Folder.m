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
    NSArray *allPaths = [fileManager contentsOfDirectoryAtPath:[self.url path] error:nil];
    NSMutableArray *folderObjects = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *fileObjects = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSString *currentName in allPaths) {
        NSString *escapedName = [currentName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *currentURL = [[NSURL alloc] initWithString:escapedName relativeToURL:self.url];
        
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
    BOOL isRemovalSuccessful = [fileManager removeItemAtURL:self.url error:&error];
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
    NSString *escapedName = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *newURL = [NSURL URLWithString:escapedName relativeToURL:self.parent.url];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL isRenameSuccessful = [fileManager moveItemAtURL:self.url toURL:newURL error:&error];
    if (isRenameSuccessful) {
        [[self parent] flagForRefresh];
        [self setName:name];
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
    
    NSURL *newFolderURL = [NSURL URLWithString:formattedName relativeToURL:self.url];
    
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
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Get the new URL.
    NSString *escapedName = [[file name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *newURL = [NSURL URLWithString:escapedName relativeToURL:self.url];
    
    // Move the file on the disk.
    NSError *error;
    BOOL isMoveSuccessful = [fileManager moveItemAtURL:[file url] toURL:newURL error:&error];
    
    // Handle the outcome.
    if (isMoveSuccessful) {
        [file setUrl:newURL];
        [file setParent:self];
        
        // Possibly look into updating contents list manually.
        [self flagForRefresh];
    } else {
        NSLog(@"%@", error);
    }
    
    return isMoveSuccessful;
}

// Looks for a FileObject with the given name within this folder.
// Returns the FileObject if found, nil otherwise.
// NOTE: This runs in O(n) where n is number of objects in the folder.
- (FileObject*)retrieveObjectWithName:(NSString*)name
{
    NSArray *contents = [self getContents];
    
    for (FileObject *currentObject in contents) {
        if ([[currentObject name] isEqualToString:name]) {
            return currentObject;
        }
    }
    
    return nil;
}

@end
