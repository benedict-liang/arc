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
    NSArray *allContents = [localFileContents arrayByAddingObject:[DropBoxRootFolder sharedDropBoxRootFolder]];
    _contents = allContents;
    _needsRefresh = NO;
    return _contents;
}

@end
