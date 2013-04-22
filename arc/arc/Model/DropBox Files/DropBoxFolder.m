//
//  DropBoxFolder.m
//  arc
//
//  Created by Jerome Cheng on 1/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "DropBoxFolder.h"

@implementation DropBoxFolder

// Synthesize protocol properties.
@synthesize name=_name, identifier=_path, parent=_parent, isRemovable=_isRemovable, size=_size, delegate=_delegate;

// Initialises this object with the given name, path, and parent.
- (id)initWithName:(NSString *)name identifier:(NSString *)path parent:(id<FileSystemObject>)parent
{
    if (self = [super init]) {
        _name = name;
        _path = path;
        _parent = parent;
        _isRemovable = YES;
    }
    return self;
}

- (void)setDelegate:(id<FolderDelegate>)delegate
{
    _delegate = delegate;
    
    DBFilesystem *filesystem = [DBFilesystem sharedFilesystem];
    [filesystem addObserver:self forPathAndChildren:[[DBPath alloc] initWithString:_path] block:^{
        [_delegate folderContentsUpdated:self];
    }];
}

// Returns the contents of this object.
- (id<NSObject>)contents
{
    DBPath *path = [[DBPath alloc] initWithString:_path];
    DBFilesystem *filesystem = [DBFilesystem sharedFilesystem];
    
    DBError *error;
    NSArray *retrievedFileInfo = [filesystem listFolder:path error:&error];
    NSMutableArray *contents = [[NSMutableArray alloc] init];
    if (retrievedFileInfo) {
        for (DBFileInfo *currentInfo in retrievedFileInfo) {
            DBPath *currentPath = [currentInfo path];
            NSString *currentPathString = [currentPath stringValue];
            NSString *currentName = [currentPath name];
            
            id<FileSystemObject>currentObject;
            if ([currentInfo isFolder]) {
                currentObject = [[DropBoxFolder alloc] initWithName:currentName identifier:currentPathString parent:self];
            } else {
                currentObject = [[DropBoxFile alloc] initWithName:currentName identifier:currentPathString parent:self];
                
                DBFile *currentFile = [filesystem openFile:[[DBPath alloc] initWithString:currentPathString] error:nil];
                BOOL isFileCached = [[currentFile status] cached];
                [(DropBoxFile *)currentObject setIsAvailable:isFileCached];
                [currentFile close];
            }
            [contents addObject:currentObject];
        }
        
        return contents;
    } else {
        NSLog(@"%@", error);
        return nil;
    }
}

// Returns the size of this object.
// Folders should return the number of objects within, Files their size in B.
- (float)size
{
    return [(NSArray *)[self contents] count];
}

// Moves the given FileSystemObject to this Folder.
// The given file must be of the same "type" as this Folder
// (e.g. iOS file system, DropBox, etc.)
// Returns YES if successful, NO otherwise.
- (BOOL)takeFileSystemObject:(id<FileSystemObject>)target
{
    DBPath *targetPath = [[DBPath alloc] initWithString:[target identifier]];
    if (targetPath) {
        DBPath *ourPath = [[DBPath alloc] initWithString:_path];
        DBPath *newPath = [ourPath childPath:[targetPath name]];
        
        DBFilesystem *filesystem = [DBFilesystem sharedFilesystem];
        DBError *error;
        
        BOOL isMoveSuccessful = [filesystem movePath:targetPath toPath:newPath error:&error];
        if (isMoveSuccessful) {
            [target setParent:self];
            [target setIdentifier:[newPath stringValue]];
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
    DBPath *ourPath = [[DBPath alloc] initWithString:_path];
    DBPath *childPath = [ourPath childPath:name];
    
    DBFilesystem *filesystem = [DBFilesystem sharedFilesystem];
    
    DBError *error;
    BOOL isCreateSuccessful = [filesystem createFolder:childPath error:&error];

    if (isCreateSuccessful) {
        DropBoxFolder *newFolder = [[DropBoxFolder alloc] initWithName:name identifier:[childPath stringValue] parent:self];
        return newFolder;
    } else {
        NSLog(@"%@", error);
        return nil;
    }
}

// Renames this Folder to the given name.
- (BOOL)rename:(NSString *)name
{
    DBPath *parentPath = [[DBPath alloc] initWithString:[_parent identifier]];
    DBPath *newPath = [parentPath childPath:name];
    DBPath *ourPath = [[DBPath alloc] initWithString:_path];
    
    DBFilesystem *filesystem = [DBFilesystem sharedFilesystem];
    
    DBError *error;
    BOOL isRenameSuccessful = [filesystem movePath:ourPath toPath:newPath error:&error];

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
    DBPath *ourPath = [[DBPath alloc] initWithString:_path];
    
    DBFilesystem *filesystem = [DBFilesystem sharedFilesystem];
    
    DBError *error;
    BOOL isRemoveSuccessful = [filesystem deletePath:ourPath error:&error];
    
    if (!isRemoveSuccessful) {
        NSLog(@"%@", error);
    }
    return isRemoveSuccessful;
}
// Given a FileSystemObject path, searches for and returns the object
// at that path.
- (id<FileSystemObject>)objectAtPath:(NSString *)path
{
    NSString *commonPrefix = [[self identifier] commonPrefixWithString:path options:NSCaseInsensitiveSearch];
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
        DropBoxFolder *nextSearch = (DropBoxFolder *)[self retrieveItemWithName:nextFolderName];
        
        return [nextSearch objectAtPath:path];
    }
}

@end
