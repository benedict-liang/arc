//
//  File.m
//  arc
//
//  Created by Jerome Cheng on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "File.h"
#import "Folder.h"

@implementation File

// Creates a file with the given name and contents, in the given folder.
// Returns a reference to the file.
+ (id)fileWithName:(NSString*)name Contents:(NSString*)contents inFolder:(Folder*)folder
{
    // Escape the file name.
    NSString *escapedName = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // Get the URL for the new file.
    NSURL *folderURL = [NSURL URLWithString:[folder path]];
    NSURL *fileURL = [NSURL URLWithString:escapedName relativeToURL:folderURL];
    
    // Write the file.
    NSError *error;
    BOOL isWriteSuccessful = [contents writeToFile:[fileURL path] atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (isWriteSuccessful) {
        [folder flagForRefresh];
        return [[File alloc] initWithURL:fileURL parent:folder];
    } else {
        NSLog(@"%@", error);
        return nil;
    }
}

// Refreshes the contents of this object by reloading
// them from the file system.
// Returns the contents when done.
// File returns an NSString of the text contained within it.
- (id)refreshContents
{
    _contents = [NSString stringWithContentsOfFile:[_url path] encoding:NSUTF8StringEncoding error:nil];
    _needsRefresh = NO;
    return _contents;
}

// Removes this object from the file system.
- (BOOL)remove
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL isRemovalSuccessful = [fileManager removeItemAtURL:_url error:&error];
    if (isRemovalSuccessful) {
        [[self parent] flagForRefresh];
    } else {
        NSLog(@"%@", error);
    }
    return isRemovalSuccessful;
}

@end
