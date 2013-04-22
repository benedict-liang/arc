//
//  SyntaxParserResult.m
//  arc
//
//  Created by omer iqbal on 22/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SyntaxParserResult.h"

@implementation SyntaxParserResult

- (id)initWithScope:(NSString *)scope Ranges:(NSArray *)ranges CPS:(NSArray *)cps{
    _scope = scope;
    _ranges = [NSMutableArray arrayWithArray:ranges];
    _capturableScopes = cps;
    return self;
}
- (id)initWithScope:(NSString *)scope Ranges:(NSArray *)ranges {
    return [self initWithScope:scope Ranges:ranges CPS:nil];
}
@end
