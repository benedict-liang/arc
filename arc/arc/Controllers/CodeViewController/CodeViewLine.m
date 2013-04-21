//
//  CodeViewLine.m
//  arc
//
//  Created by Yong Michael on 17/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "CodeViewLine.h"

@implementation CodeViewLine
@synthesize range = _range;
@synthesize lineStart = _lineStart;
@synthesize lineNumber = _lineNumber;
@synthesize visible = _visible;

- (id)initWithRange:(NSRange)range
{
    self = [super init];
    if (self) {
        _range = range;
        _lineNumber = 0;
        _lineStart = NO;
        _visible = YES;
    }
    return self;
}

- (id)initWithRange:(NSRange)range AndLineNumber:(NSUInteger)lineNumber
{
    self = [super init];
    if (self) {
        _range = range;
        _lineNumber = lineNumber;
        _lineStart = YES;
        _visible = YES;
    }
    return self;
}

@end
