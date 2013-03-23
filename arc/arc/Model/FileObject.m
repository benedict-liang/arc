//
//  FileObject.m
//  arc
//
//  Created by Jerome Cheng on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FileObject.h"

@implementation FileObject

// Creates a FileObject to represent the given URL.
// url should be an object on the file system.
- (id)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        NSURL *filePathUrl = [url filePathURL];
        _name = [filePathUrl lastPathComponent];
        _path = [filePathUrl absoluteString];
        _url = filePathUrl;
    }
    return self;
}

// Creates a FileObject to represent the given URL,
// with its parent set to the given FileObject.
- (id)initWithURL:(NSURL *)url parent:(FileObject *)parent
{
    if (self = [self initWithURL:url]) {
        _parent = parent;
    }
    return self;
}

// Gets the contents of this object.
- (id)getContents
{
    // This implementation allows for "lazy" initialisation
    // of the entire file system structure (instead of recursively
    // creating it when the root is initialised.)
    
    // Check if the contents have been initialised.
    if (_contents == nil) {
        // They haven't.
        return [self refreshContents];
    } else {
        return _contents;
    }
}

// Refreshes the contents of this object by reloading them
// from the file system.
// Returns the contents when done.
- (id)refreshContents
{
    // This method must be implemented in a subclass.
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"Method %@ not implemented in FileObject.", NSStringFromSelector(_cmd)] userInfo:nil];
}

// Removes this object from the file system.
- (void)remove
{
    // This method must be implemented in a subclass.
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"Method %@ not implemented in FileObject.", NSStringFromSelector(_cmd)] userInfo:nil];
}

@end
