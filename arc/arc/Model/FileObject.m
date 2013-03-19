//
//  FileObject.m
//  arc
//
//  Created by Jerome Cheng on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FileObject.h"

@implementation FileObject

- (id)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        NSURL *filePathUrl = [url filePathURL];
        _name = [filePathUrl lastPathComponent];
        _path = [filePathUrl absoluteString];
    }
    return self;
}

@end
