//
//  LocalFolder.m
//  arc
//
//  Created by Jerome Cheng on 1/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "LocalFolder.h"

@implementation LocalFolder

// Synthesize properties from protocol.
@synthesize name=_name, path=_path, parent=_parent, isRemovable=_isRemovable;

// Initialises this object with the given name, path, and parent.
- (id)initWithName:(NSString *)name path:(NSString *)path parent:(id<FileSystemObject>)parent
{
    if (self = [super init]) {
        _name = name;
        _path = path;
        _parent = parent;
        _isRemovable = YES;
    }
    return self;
}

// Returns the contents of this object.
- (id<NSObject>)contents
{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSError *error;
    NSArray *retrievedContents = [fileManager contentsOfDirectoryAtPath:_path error:&error];
    
    if (error) {
        NSLog(@"%@", error);
        return nil;
    } else {
        NSMutableArray *contents = [[NSMutableArray alloc] init];
        
        for (NSString *currentRelativePath in retrievedContents) {
            NSString *itemName = currentRelativePath;
            NSString *readableName = [currentRelativePath stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *currentPath = [_path stringByAppendingPathComponent:itemName];
            
            id<FileSystemObject>retrievedObject;
            BOOL isCurrentPathDirectory;
            [fileManager fileExistsAtPath:currentPath isDirectory:&isCurrentPathDirectory];
            if (isCurrentPathDirectory) {
                retrievedObject = [[LocalFolder alloc] initWithName:readableName path:currentPath parent:self];
            } else {
                retrievedObject = [[LocalFile alloc] initWithName:readableName path:currentPath parent:self];
            }
            [contents addObject:retrievedObject];
        }
        return contents;
    }
}

// Returns the size of this object.
// Folders should return the number of objects within, Files their size in B.
- (int)size
{
    return [(NSArray *)[self contents] count];
}

// Moves the given FileSystemObject to this Folder.
// The given file must be of the same "type" as this Folder
// (e.g. iOS file system, DropBox, etc.)
// Returns YES if successful, NO otherwise.
- (BOOL)takeFileSystemObject:(id<FileSystemObject>)target
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:[target path]]) {
        NSString *newTargetPath = [_path stringByAppendingPathComponent:[[target path] lastPathComponent]];
        
        NSError *error;
        BOOL isMoveSuccessful = [fileManager moveItemAtPath:[target path] toPath:newTargetPath error:&error];
        if (isMoveSuccessful) {
            [target setParent:self];
            [target setPath:newTargetPath];
        } else {
            NSLog(@"%@", error);
        }
        return isMoveSuccessful;
    } else {
        return NO;
    }
}

// Returns the FileSystemObject with the given name.
// Will return nil if the object is not found.
- (id<FileSystemObject>)retrieveItemWithName:(NSString *)name
{
    NSArray *contents = (NSArray *)[self contents];
    for (id<FileSystemObject>currentObject in contents) {
        if ([[currentObject name] isEqualToString:name]) {
            return currentObject;
        }
    }
    return nil;
}

// Creates a Folder with the given name inside this one.
// Returns the created Folder object.
- (id<Folder>)createFolderWithName:(NSString *)name
{
    NSString *escapedName = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *newFolderPath = [_path stringByAppendingPathComponent:escapedName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSError *error;
    BOOL isCreateSuccessful = [fileManager createDirectoryAtPath:newFolderPath withIntermediateDirectories:YES attributes:nil error:&error];
   
    if (isCreateSuccessful) {
        LocalFolder *newFolder = [[LocalFolder alloc] initWithName:name path:newFolderPath parent:self];
        return newFolder;
    } else {
        NSLog(@"%@", error);
        return nil;
    }
}

// Renames this Folder to the given name.
- (BOOL)rename:(NSString *)name
{
    NSString *escapedName = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *newPath = [[_parent path] stringByAppendingPathComponent:escapedName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSError *error;
    BOOL isRenameSuccessful = [fileManager moveItemAtPath:_path toPath:newPath error:&error];

    if (isRenameSuccessful) {
        _name = name;
    } else {
        NSLog(@"%@", error);
    }
    return isRenameSuccessful;
}

// Removes this object.
// Returns YES if successful, NO otherwise.
// If NO is returned, the state of the object or its contents is unstable.
- (BOOL)remove
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error;
    BOOL isRemoveSuccessful = [fileManager removeItemAtPath:_path error:&error];
    
    if (!isRemoveSuccessful) {
        NSLog(@"%@", error);
    }
    return isRemoveSuccessful;
}

// Given a FileSystemObject path, searches for and returns the object
// at that path.
- (id<FileSystemObject>)objectAtPath:(NSString *)path
{
    NSString *commonPrefix = [[self path] commonPrefixWithString:path options:NSCaseInsensitiveSearch];
    NSString *newPathString = [path substringFromIndex:[commonPrefix length]];
    
    NSArray *pathComponents = [newPathString pathComponents];
    
    if ([pathComponents count] == 0) {
        return self;
    } else if ([pathComponents count] == 2) {
        // The object should be in this folder. Return it.
        NSString *unescapedName = [[pathComponents objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        return [self retrieveItemWithName:unescapedName];
    } else {
        // Get the next folder.
        NSString *nextFolderName = [pathComponents objectAtIndex:1];
        LocalFolder *nextSearch = (LocalFolder *)[self retrieveItemWithName:nextFolderName];
        
        return [nextSearch objectAtPath:path];
    }
}

@end
