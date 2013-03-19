//
//  FileSystem.m
//  arc
//
//  Created by Jerome Cheng on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FileSystem.h"

static FileSystem *singleton;

@implementation FileSystem

+ (void) initialize
{
    static BOOL initialized = NO;
    if (!initialized)
    {
        initialized = YES;
        singleton = [[FileSystem alloc] init];
    }
}

- (id) init
{
    self = [super init];
    if (self) {
        // Set up the root folder.
        
    }
}

@end
