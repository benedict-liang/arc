//
//  File.m
//  arc
//
//  Created by Jerome Cheng on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "File.h"

@implementation File

// Refreshes the contents of this object by reloading
// them from the file system.
// Returns the contents when done.
// File returns an NSString of the text contained within it.
- (id)refreshContents
{
    _contents = [NSString stringWithContentsOfFile:[self path] encoding:NSUTF8StringEncoding error:nil];
    return _contents;
}

@end
