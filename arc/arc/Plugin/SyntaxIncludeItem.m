//
//  SyntaxIncludeItem.m
//  arc
//
//  Created by omer iqbal on 22/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SyntaxIncludeItem.h"

@implementation SyntaxIncludeItem
- (id)initWithInclude:(NSString *)i {
    if (self = [super init]) {
        _include = i;
    }
    return self;
}
- (SyntaxMatchStore*)parseContent:(NSString *)content WithRange:(NSRange)range {
    return [[SyntaxMatchStore alloc] init];
}
@end
