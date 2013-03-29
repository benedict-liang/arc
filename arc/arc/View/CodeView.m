//
//  CodeView.m
//  arc
//
//  Created by Yong Michael on 30/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "CodeView.h"

@implementation CodeView

- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.autoresizesSubviews = YES;
        self.scrollEnabled = YES;
    }
    return self;
}

@end
