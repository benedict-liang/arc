//
//  FileSystem.m
//  arc
//
//  Created by Jerome Cheng on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FileSystem.h"

static FileSystem *singleton = nil;

@implementation FileSystem

+ (FileSystem*)getInstance
{
    if (singleton == nil) {
        singleton = [[super allocWithZone:NULL] init];
    }
    return singleton;
}


- (id)init
{
    self = [super init];
    if (self) {
        // Set up the root folder.
        
    }
    return self;
}

@end
