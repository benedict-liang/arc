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

@end
