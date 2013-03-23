//
//  Folder.m
//  arc
//
//  Created by Jerome Cheng on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "Folder.h"

@implementation Folder

// Refreshes the contents of this object by reloading them
// from the file system.
// Returns the contents when done.
// Folder returns an NSArray of FileObjects contained within it.
- (id)refreshContents
{
    // Load the contents of this folder.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *allPaths = [fileManager contentsOfDirectoryAtPath:[self path] error:nil];
    NSMutableArray *folderObjects = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *fileObjects = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSString *currentPath in allPaths) {
        NSURL *currentURL = [[NSURL alloc] initWithString:currentPath];
        BOOL isCurrentDirectory;
        [fileManager fileExistsAtPath:currentPath isDirectory:&isCurrentDirectory];
        if (isCurrentDirectory) {
            Folder *currentFolder = [[Folder alloc] initWithURL:currentURL parent:self];
            [folderObjects addObject:currentFolder];
        } else {
            File *currentFile = [[File alloc] initWithURL:currentURL parent:self];
            [fileObjects addObject:currentFile];
        }
    }
    
    [folderObjects addObjectsFromArray:fileObjects];
    _contents = folderObjects;
    return folderObjects;
}

@end
