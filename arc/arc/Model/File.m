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

// Creates a File to represent the given URL,
// with its parent set to the given FileObject.
- (id)initWithURL:(NSURL *)url parent:(FileObject *)parent
{
    if (self = [super initWithURL:url parent:parent]) {
        _extension = [self.name pathExtension];
    }
    return self;
}

// Creates a file with the given name and contents, in the given folder.
// Returns a reference to the file.
+ (id)fileWithName:(NSString*)name Contents:(NSString*)contents inFolder:(Folder*)folder
{
    // Escape the file name.
    NSString *escapedName = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // Get the URL for the new file.
    NSURL *fileURL = [NSURL URLWithString:escapedName relativeToURL:[folder url]];
    
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
    _contents = [NSString stringWithContentsOfFile:[self.url path] encoding:NSUTF8StringEncoding error:nil];
    _needsRefresh = NO;
    return _contents;
}

// Removes this object from the file system.
- (BOOL)remove
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL isRemovalSuccessful = [fileManager removeItemAtURL:self.url error:&error];
    if (isRemovalSuccessful) {
        [[self parent] flagForRefresh];
    } else {
        NSLog(@"%@", error);
    }
    return isRemovalSuccessful;
}

@end
