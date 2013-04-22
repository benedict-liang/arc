//
//  SyntaxParserResult.m
//  arc
//
//  Created by omer iqbal on 22/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SyntaxParserResult.h"

@implementation SyntaxParserResult

- (id)initWithScope:(NSString *)scope Ranges:(NSArray *)ranges {
    _scope = scope;
    _ranges = [NSMutableArray arrayWithArray:ranges];
    return self;
}
@end
