//
//  ScopeRange.m
//  arc
//
//  Created by omer iqbal on 24/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ScopeRange.h"

@implementation ScopeRange

- (id)initWithScope:(NSString *)s Range:(NSRange)r {
    _scope = s;
    _range = r;
    return self;
}
+ (ScopeRange*)scope:(NSString *)s Range:(NSRange)r {
    return [[ScopeRange alloc] initWithScope:s Range:r];
}
@end
