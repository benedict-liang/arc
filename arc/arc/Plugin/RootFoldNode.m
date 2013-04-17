//
//  RootFoldNode.m
//  arc
//
//  Created by omer iqbal on 17/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "RootFoldNode.h"

@implementation RootFoldNode
@synthesize type = _type;
- (id)initWithContentRange:(NSRange)cr {
    
    self = [super initWithContentRange:cr startRange:NSMakeRange(0, 0) endRange:NSMakeRange(0, 0)];
    if (self) {
        _type = kRootNode;
    }
    return self;
}
@end
