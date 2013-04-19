//
//  DropBoxRootFolder.m
//  arc
//
//  Created by Jerome Cheng on 1/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "DropBoxRootFolder.h"

static DropBoxRootFolder *sharedDropBoxRootFolder = nil;

@implementation DropBoxRootFolder

@synthesize isRemovable=_isRemovable;

+ (DropBoxRootFolder *)sharedDropBoxRootFolder
{
    if (sharedDropBoxRootFolder == nil) {
        sharedDropBoxRootFolder = [[super allocWithZone:NULL] init];
    }
    return sharedDropBoxRootFolder;
}

- (id)init
{
    DBPath *rootPath = [DBPath root];
    NSString *ourPath = [rootPath stringValue];
    
    if (self = [super initWithName:FOLDER_DROPBOX_ROOT identifier:ourPath parent:[LocalRootFolder sharedLocalRootFolder]]) {
        _isRemovable = NO;
    }
    return self;
}


// Renames this Folder to the given name.
- (BOOL)rename:(NSString *)name
{
    // DropBoxRootFolder can't be renamed.
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"DropBoxRootFolder doesn't allow %@", NSStringFromSelector(_cmd)] userInfo:nil];
}

// Removes this object.
// Returns YES if successful, NO otherwise.
// If NO is returned, the state of the object or its contents is unstable.
- (BOOL)remove
{
    // DropBoxRootFolder can't be removed.
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"DropBoxRootFolder doesn't allow %@", NSStringFromSelector(_cmd)] userInfo:nil];
}

@end
