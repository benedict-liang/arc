//
//  RootFolder.m
//  arc
//
//  Created by Jerome Cheng on 23/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "RootFolder.h"

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

    if (self = [super initWithURL:documentUrl]) {
        [self createFolder:@"External Files"];
        
        // TEMPORARY: Create a few test files.
        File *test = [File fileWithName:@"test.txt" Contents:@"This is a test" inFolder:self];
        File *test2 = [File fileWithName:@"anotherTest.c" Contents:@"Hello world!"inFolder:self];
        File *test3 = [File fileWithName:@"and_another.test" Contents:@"Does this thing work?" inFolder:self];
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
- (id)initWithURL:(NSURL *)url {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"RootFolder doesn't allow %@", NSStringFromSelector(_cmd)] userInfo:nil];
}
- (id)initWithURL:(NSURL *)url parent:(FileObject *)parent {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"RootFolder doesn't allow %@", NSStringFromSelector(_cmd)] userInfo:nil];
}

@end
