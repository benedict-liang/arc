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
@synthesize name=_name, path=_path, parent=_parent;

// Initialises this object with the given name, path, and parent.
- (id)initWithName:(NSString *)name path:(NSString *)path parent:(id<FileSystemObject>)parent
{
    if (self = [super init]) {
        _name = name;
        _path = path;
        _parent = parent;
    }
    return self;
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
                currentObject = [[DropBoxFolder alloc] initWithName:currentName path:currentPathString parent:self];
            } else {
                currentObject = [[DropBoxFile alloc] initWithName:currentName path:currentPathString parent:self];
            }
            [contents addObject:currentObject];
        }
        
        _contents = contents;
    } else {
        NSLog(@"%@", error);
        return nil;
    }
    
    return _contents;
}

// Moves the given FileSystemObject to this Folder.
// The given file must be of the same "type" as this Folder
// (e.g. iOS file system, DropBox, etc.)
// Returns YES if successful, NO otherwise.
- (BOOL)takeFileSystemObject:(id<FileSystemObject>)target
{
    DBPath *targetPath = [[DBPath alloc] initWithString:[target path]];
    if (targetPath) {
        DBPath *ourPath = [[DBPath alloc] initWithString:_path];
        DBPath *newPath = [ourPath childPath:[targetPath name]];
        
        DBFilesystem *filesystem = [DBFilesystem sharedFilesystem];
        DBError *error;
        
        BOOL isMoveSuccessful = [filesystem movePath:targetPath toPath:newPath error:&error];
        if (isMoveSuccessful) {
            [target setParent:self];
            [target setPath:[newPath stringValue]];
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
        DropBoxFolder *newFolder = [[DropBoxFolder alloc] initWithName:name path:[childPath stringValue] parent:self];
        return newFolder;
    } else {
        NSLog(@"%@", error);
        return nil;
    }
}

// Renames this Folder to the given name.
- (BOOL)rename:(NSString *)name
{
    DBPath *parentPath = [[DBPath alloc] initWithString:[_parent path]];
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

@end
