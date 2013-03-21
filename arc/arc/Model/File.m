//
//  File.m
//  arc
//
//  Created by Jerome Cheng on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "File.h"

@implementation File

- (id)initWithURL:(NSURL *)url {
    self = [super initWithURL:url];
    if (self) {
        [self setContents:[NSString stringWithContentsOfFile:[self path] encoding:NSUTF8StringEncoding error:nil]];
    }
    return self;
}

@end
