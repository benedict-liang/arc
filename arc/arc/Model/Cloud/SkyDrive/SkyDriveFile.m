//
//  SkyDriveFile.m
//  arc
//
//  Created by Jerome Cheng on 14/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SkyDriveFile.h"

@implementation SkyDriveFile
@synthesize name=_name, path=_path, parent=_parent, isRemovable=_isRemovable, extension=_extension;

// Initialises this object with the given name, path, and parent.
- (id)initWithName:(NSString *)name path:(NSString *)path parent:(id<FileSystemObject>)parent
{
    if (self = [super init]) {
        _name = name;
        _path = path;
        _parent = parent;
        _extension = [name pathExtension];
        _isRemovable = NO;
    }
    return self;
}

// Returns the contents of this object.
- (id<NSObject>)contents
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"SkyDriveFile doesn't allow %@", NSStringFromSelector(_cmd)] userInfo:nil];
}

// Returns the size of this object.
// Folders should return the number of objects within, Files their size in B.
- (int)size
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"SkyDriveFile doesn't allow %@", NSStringFromSelector(_cmd)] userInfo:nil];
}

// Removes this object.
// Returns YES if successful, NO otherwise.
// If NO is returned, the state of the object or its contents is unstable.
- (BOOL)remove
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"SkyDriveFile doesn't allow %@", NSStringFromSelector(_cmd)] userInfo:nil];
}

@end
