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

- (Folder*)getRootFolder
{
    return _rootFolder;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Set up the root folder.
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *documentUrl = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
        _rootFolder = [[Folder alloc] initWithURL:documentUrl];
    }
    return self;
}

// Returns an NSArray of FileObjects, corresponding to the contents
// of the given folder.
- (NSArray*)getFolderContents:(Folder *)folder
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *allPaths = [fileManager contentsOfDirectoryAtPath:[folder path] error:nil];
    NSMutableArray *folderObjects = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *fileObjects = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSString *currentPath in allPaths) {
        NSURL *currentURL = [[NSURL alloc] initWithString:currentPath];
        if ([fileManager fileExistsAtPath:currentPath isDirectory:YES]) {
            Folder *currentFolder = [[Folder alloc] initWithURL:currentURL];
            [folderObjects addObject:currentFolder];
        } else {
            File *currentFile = [[File alloc] initWithURL:currentURL];
            [fileObjects addObject:currentFile];
        }
    }
    
    [folderObjects addObjectsFromArray:fileObjects];
    return folderObjects;
}

// Returns an NSString containing the contents of the given file.
- (NSString*)getFileContents:(File*)file
{
    return [NSString stringWithContentsOfFile:[file path] encoding:NSUTF8StringEncoding error:nil];
}

@end
