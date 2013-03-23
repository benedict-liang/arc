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

@end
