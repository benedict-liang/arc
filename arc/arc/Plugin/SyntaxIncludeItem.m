//
//  SyntaxIncludeItem.m
//  arc
//
//  Created by omer iqbal on 22/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SyntaxIncludeItem.h"

@implementation SyntaxIncludeItem
- (id)initWithInclude:(NSString *)i Parent:(id<SyntaxPatternsDelegate>)p{
    if (self = [super init]) {
        _include = i;
        _parent = p;
    }
    return self;
}
- (SyntaxMatchStore*)parseContent:(NSString *)content WithRange:(NSRange)range {
    id<SyntaxPatternsDelegate> root = [self rootParent];
    if ([_include isEqualToString:@"$base"]) {
        //return [root parseResultsForContent:content Range:range];
        return  [[SyntaxMatchStore alloc] init];
    }
    else if([_include characterAtIndex:0]=='#') {
        NSString *str = [_include substringFromIndex:1];
        return [root parseResultsForRepoRule:str Content:content Range:range];
    }
    else {
        //TODO external include
    }
    
    return [[SyntaxMatchStore alloc] init];
}

- (id<SyntaxPatternsDelegate>)rootParent {
    id<SyntaxPatternsDelegate> pp = [_parent parent];
    NSLog(@"include root search");

    id<SyntaxPatternsDelegate> lp = pp;
    while (pp != nil) {
        lp = pp;
        //NSLog(@"%@",lp);
        pp = [pp parent];
    }
    NSLog(@"include root found");
    return lp;
}
@end
