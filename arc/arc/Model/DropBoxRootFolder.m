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
    
    if (self = [super initWithName:FOLDER_DROPBOX_ROOT path:ourPath parent:nil]) {
        
    }
    return self;
}

@end
