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
        _needsRefresh = YES;
    }
    return self;
}

@end
