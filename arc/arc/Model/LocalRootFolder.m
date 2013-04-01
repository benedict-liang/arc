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
        
    }
    return self;
}


@end
