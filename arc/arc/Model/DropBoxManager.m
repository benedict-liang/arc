//
//  DropBoxManager.m
//  arc
//
//  Created by Jerome Cheng on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "DropBoxManager.h"

@implementation DropBoxManager

// Downloads the given DBFile into the given Folder.
// Returns the resulting File object if successful, nil otherwise.
+ (File*)saveDBFile:(DBFile*)dbFile toFolder:(Folder*)folder
{
    NSString *fileName = [[[dbFile info] path] name];
    NSString *fileContents = [dbFile readString:nil];
    return [File fileWithName:fileName Contents:fileContents inFolder:folder];
}

@end
