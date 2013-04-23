//
//  ScopeRange.m
//  arc
//
//  Created by omer iqbal on 24/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ScopeRange.h"

@implementation ScopeRange

- (id)initWithScope:(NSString *)s Range:(NSRange)r CPS:(NSArray *)cps{
    _scope = s;
    _range = r;
    _capturableScopes = cps;
    return self;
}
+ (ScopeRange*)scope:(NSString *)s Range:(NSRange)r CPS:(NSArray *)cps{
    return [[ScopeRange alloc] initWithScope:s Range:r CPS:cps];
}
- (ScopeRange*)minByRange:(ScopeRange *)s1 {
    if (_range.location < s1.range.location) {
        return self;
    }
    return s1;
}
@end
