//
//  LocalRootFolder.m
//  arc
//
//  Created by Jerome Cheng on 1/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "LocalRootFolder.h"

static LocalRootFolder *sharedLocalRootFolder = nil;

@implementation LocalRootFolder

@synthesize isRemovable = _isRemovable;

+ (LocalRootFolder*)sharedLocalRootFolder
{
    if (sharedLocalRootFolder == nil) {
        sharedLocalRootFolder = [[super allocWithZone:NULL] init];
    }
    return sharedLocalRootFolder;
}

- (id)init
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [[fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil] path];
    
    if (self = [super initWithName:FOLDER_ROOT path:documentsPath parent:nil]) {
        _isRemovable = NO;
    }
    return self;
}

// Renames this Folder to the given name.
- (BOOL)rename:(NSString *)name
{
    // LocalRootFolder can't be renamed.
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"LocalRootFolder doesn't allow %@", NSStringFromSelector(_cmd)] userInfo:nil];
}

// Removes this object.
// Returns YES if successful, NO otherwise.
// If NO is returned, the state of the object or its contents is unstable.
- (BOOL)remove
{
    // LocalRootFolder can't be removed.
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"LocalRootFolder doesn't allow %@", NSStringFromSelector(_cmd)] userInfo:nil];
}

@end
