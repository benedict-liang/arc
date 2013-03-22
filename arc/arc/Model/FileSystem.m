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
        
        // If it doesn't already exist, create the "External" folder.
        NSURL *externalRelativeUrl = [NSURL URLWithString:@"./Received%20Documents/" relativeToURL:documentUrl];
        BOOL createdRelative = [fileManager createDirectoryAtURL:externalRelativeUrl withIntermediateDirectories:YES attributes:nil error:nil];
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
        BOOL isCurrentDirectory;
        [fileManager fileExistsAtPath:currentPath isDirectory:&isCurrentDirectory];
        if (isCurrentDirectory) {
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

// Creates a folder with the given name within the given folder.
// Returns YES if successful, NO otherwise.
- (BOOL)createFolderWithName:(NSString*)name inFolder:(Folder*)folder
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Replace all spaces in the string with %20.
    // (This is an existing pre-defined method. Wow.)
    NSString *escapedName = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // Add a / to the end, if necessary.
    NSString *formattedName;
    if ([escapedName hasSuffix:@"/"]) {
        formattedName = escapedName;
    } else {
        formattedName = [escapedName stringByAppendingString:@"/"];
    }
    
    NSURL *currentFolderURL = [NSURL URLWithString:[folder path]];
    NSURL *newFolderURL = [NSURL URLWithString:formattedName relativeToURL:currentFolderURL];
    
    return [fileManager createDirectoryAtURL:newFolderURL withIntermediateDirectories:YES attributes:nil error:nil];
}

@end
