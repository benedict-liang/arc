//
//  RootFolder.m
//  arc
//
//  Created by Jerome Cheng on 1/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "RootFolder.h"

@interface RootFolder ()
@property (nonatomic) NSArray *contents;
@end

static RootFolder *sharedRootFolder = nil;

@implementation RootFolder

// Synthesize properties from protocol.
@synthesize name=_name, path=_path, parent=_parent, isRemovable=_isRemovable, size=_size;

+ (RootFolder *)sharedRootFolder
{
    if (sharedRootFolder == nil) {
        sharedRootFolder = [[super allocWithZone:NULL] init];
    }
    return sharedRootFolder;
}

- (id)init
{
    if (self = [super init]) {
        LocalRootFolder *localRoot = [LocalRootFolder sharedLocalRootFolder];
        _name = [localRoot name];
        _path = [localRoot path];
        _parent = nil;
        _isRemovable = NO;
    }
    return self;
}

// Returns the contents of this object.
- (id<NSObject>)contents
{
    NSArray *localFileContents = (NSArray *)[[LocalRootFolder sharedLocalRootFolder] contents];

    if ([[DBAccountManager sharedManager] linkedAccount]) {
        _contents = [localFileContents arrayByAddingObject:[DropBoxRootFolder sharedDropBoxRootFolder]];
    } else {
        _contents = localFileContents;
    }
    return _contents;
}

// Returns the size of this object.
// Folders should return the number of objects within, Files their size in B.
- (float)size
{
    return [_contents count];
}

// Initialises this object with the given name, path, and parent.
- (id)initWithName:(NSString *)name path:(NSString *)path parent:(id<FileSystemObject>)parent
{
    // RootFolder can't be initialised manually.
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"RootFolder doesn't allow %@", NSStringFromSelector(_cmd)] userInfo:nil];
}

// Given a FileSystemObject path, searches for and returns the object
// at that path.
- (id<FileSystemObject>)objectAtPath:(NSString *)path
{
    if ([path isEqualToString:_path]) {
        return self;
    }
    
    // If we have DropBox, check if it's in the DropBox folder.
    if ([[DBAccountManager sharedManager] linkedAccount]) {
        id<FileSystemObject> dropBoxObject = [[DropBoxRootFolder sharedDropBoxRootFolder] objectAtPath:path];
        if (dropBoxObject) {
            return dropBoxObject;
        }
    }
    
    // Check the local file system.
    return [[LocalRootFolder sharedLocalRootFolder] objectAtPath:path];
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
