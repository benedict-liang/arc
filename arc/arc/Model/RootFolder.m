//
//  RootFolder.m
//  arc
//
//  Created by Jerome Cheng on 1/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "RootFolder.h"

static RootFolder *sharedRootFolder = nil;

@implementation RootFolder

// Synthesize properties from protocol.
@synthesize name=_name, path=_path, parent=_parent;

+ (RootFolder *)sharedRootFolder
{
    if (sharedRootFolder == nil) {
        sharedRootFolder = [[super allocWithZone:NULL] init];
    }
    return sharedRootFolder;
}

// Returns the contents of this object.
- (id<NSObject>)contents
{
    if (_needsRefresh) {
        return [self refreshContents];
    } else {
        return _contents;
    }
}

// Refreshes the contents of this object, and returns them (for convenience.)
- (id<NSObject>)refreshContents
{
    NSArray *localFileContents = (NSArray *)[[LocalRootFolder sharedLocalRootFolder] refreshContents];

    if ([[DBAccountManager sharedManager] linkedAccount]) {
        _contents = [localFileContents arrayByAddingObject:[DropBoxRootFolder sharedDropBoxRootFolder]];
    } else {
        _contents = localFileContents;
    }
    _needsRefresh = NO;
    return _contents;
}

// Marks this object as needing to be refreshed.
- (void)markNeedsRefresh
{
    [[LocalRootFolder sharedLocalRootFolder] markNeedsRefresh];
}

// Initialises this object with the given name, path, and parent.
- (id)initWithName:(NSString *)name path:(NSString *)path parent:(id<FileSystemObject>)parent
{
    // RootFolder can't be initialised manually.
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"RootFolder doesn't allow %@", NSStringFromSelector(_cmd)] userInfo:nil];
}

// Moves the given FileSystemObject to this Folder.
// The given file must be of the same "type" as this Folder
// (e.g. iOS file system, DropBox, etc.)
// Returns YES if successful, NO otherwise.
- (BOOL)takeFileSystemObject:(id<FileSystemObject>)target
{
    return [[LocalRootFolder sharedLocalRootFolder] takeFileSystemObject:target];
}

// Returns the FileSystemObject with the given name.
// Will return nil if the object is not found.
- (id<FileSystemObject>)retrieveItemWithName:(NSString *)name
{
    return [[LocalRootFolder sharedLocalRootFolder] retrieveItemWithName:name];
}

// Creates a Folder with the given name inside this one.
// Returns the created Folder object.
- (id<Folder>)createFolderWithName:(NSString *)name
{
    return [[LocalRootFolder sharedLocalRootFolder] createFolderWithName:name];
}


// Renames this Folder to the given name.
- (BOOL)rename:(NSString *)name
{
    return [[LocalRootFolder sharedLocalRootFolder] rename:name];
}

// Removes this object.
// Returns YES if successful, NO otherwise.
// If NO is returned, the state of the object or its contents is unstable.
- (BOOL)remove
{
    return [[LocalRootFolder sharedLocalRootFolder] remove];
}

@end
