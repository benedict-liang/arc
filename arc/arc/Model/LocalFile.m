//
//  LocalFile.m
//  arc
//
//  Created by Jerome Cheng on 1/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "LocalFile.h"

@implementation LocalFile

// Synthesize properties from protocol.
@synthesize name=_name, path=_path, parent=_parent, extension=_extension;

// Initialises this object with the given name, path, and parent.
- (id)initWithName:(NSString*)name path:(NSString*)path parent:(id<FileSystemObject>)parent
{
    if (self = [super init]) {
        _name = name;
        _path = path;
        _parent = parent;
        _extension = [name pathExtension];
        _needsRefresh = YES;
    }
    return self;
}

// Returns the contents of this object.
- (id<NSObject>)contents
{
    if (_needsRefresh) {
        return [self refreshContents];
    } else {
        return _contents;
    }
}

// Refreshes the contents of this object, and returns them (for convenience.)
- (id<NSObject>)refreshContents
{
    NSError *error;
    NSString *retrievedContents = [NSString stringWithContentsOfFile:_path encoding:NSUTF8StringEncoding error:&error];
    
    if (error) {
        NSLog(@"%@", error);
    } else {
        _needsRefresh = NO;
        _contents = retrievedContents;
    }
    return _contents;
}

// Marks this object as needing to be refreshed.
- (void)markNeedsRefresh
{
    _needsRefresh = YES;
}

@end
