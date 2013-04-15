//
//  ArcAttribute.m
//  arc
//
//  Created by Yong Michael on 15/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ArcAttribute.h"

@implementation ArcAttribute
@synthesize range = _range;
@synthesize value = _value;
@synthesize type = _type;

- (id)initWithType:(NSString *)type withValue:(id)value onRange:(NSRange)range
{
    self = [super init];
    if (self) {
        _type = type;
        _range = range;
        _value = value;
    }
    return self;
}

@end

