//
//  File.m
//  arc
//
//  Created by Jerome Cheng on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "File.h"

@implementation File

// Creates a file with the given name and contents, in the given folder.
// Returns a reference to the file.
- (id)fileWithName:(NSString*)name Contents:(NSString*)contents inFolder:(Folder*)folder
{
    // Get the URL for the new file.
    NSString *path = [[folder path] stringByAppendingPathComponent:name];
    NSURL *fileURL = [NSURL URLWithString:path];
    
    // Write the file.
    BOOL isWriteSuccessful = [contents writeToURL:fileURL atomically:YES encoding:NSUTF8StringEncoding error:nil];
    if (isWriteSuccessful) {
        [folder flagForRefresh];
        return [[File alloc] initWithURL:fileURL parent:folder];
    } else {
        return nil;
    }
}

// Refreshes the contents of this object by reloading
// them from the file system.
// Returns the contents when done.
// File returns an NSString of the text contained within it.
- (id)refreshContents
{
    _contents = [NSString stringWithContentsOfFile:[self path] encoding:NSUTF8StringEncoding error:nil];
    _needsRefresh = NO;
    return _contents;
}

// Removes this object from the file system.
- (BOOL)remove
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isRemovalSuccessful = [fileManager removeItemAtURL:_url error:nil];
    if (isRemovalSuccessful) {
        [[self parent] flagForRefresh];
    }
    return isRemovalSuccessful;
}

@end
