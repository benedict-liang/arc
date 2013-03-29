//
//  FileObject.m
//  arc
//
//  Created by Jerome Cheng on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FileObject.h"

@implementation FileObject

// Creates a FileObject to represent the given URL,
// with its parent set to the given FileObject.
- (id)initWithURL:(NSURL *)url parent:(FileObject *)parent
{
    if (self = [super init]) {
        _name = [url lastPathComponent];
        _url = url;
        _needsRefresh = YES;
        _parent = parent;
    }
    return self;
}

// Gets the contents of this object.
- (id)contents
{
    // This implementation allows for "lazy" initialisation
    // of the entire file system structure (instead of recursively
    // creating it when the root is initialised.)
    
    if (_needsRefresh) {
        return [self refreshContents];
    } else {
        return _contents;
    }
}

// Flags this object as needing its contents refreshed.
- (void)flagForRefresh
{
    _needsRefresh = YES;
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
// Returns YES if successful, NO otherwise.
- (BOOL)remove
{
    // This method must be implemented in a subclass.
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"Method %@ not implemented in FileObject.", NSStringFromSelector(_cmd)] userInfo:nil];
}

@end
