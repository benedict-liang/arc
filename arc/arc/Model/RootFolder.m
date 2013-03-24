//
//  RootFolder.m
//  arc
//
//  Created by Jerome Cheng on 23/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "RootFolder.h"
#import "Constants.h"

static RootFolder *singleton = nil;

@implementation RootFolder

// Returns the single RootFolder instance.
+ (RootFolder*)getInstance
{
    if (singleton == nil) {
        singleton = [[super allocWithZone:NULL] init];
    }
    return singleton;
}

- (id)init
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentUrl = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];

    if (self = [super initWithURL:documentUrl parent:nil]) {
        // Create the folder to store documents from other apps.
        [self createFolder:FOLDER_EXTERNAL_APPLICATIONS];
    }
    return self;
}

// RootFolder cannot be removed.
- (BOOL)remove
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"RootFolder doesn't allow %@", NSStringFromSelector(_cmd)] userInfo:nil];
}

// RootFolder cannot be renamed.
- (BOOL)rename:(NSString *)name
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"RootFolder doesn't allow %@", NSStringFromSelector(_cmd)] userInfo:nil];
}

// RootFolder cannot be initialised externally.
- (id)initWithURL:(NSURL *)url parent:(FileObject *)parent {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"RootFolder doesn't allow %@", NSStringFromSelector(_cmd)] userInfo:nil];
}

@end
