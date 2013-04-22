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
    
    //NSLog(@"include: %@ range:%@",_include, [Utils valueFromRange:range]);
    if ([_include isEqualToString:@"$base"]) {
        //return [root parseResultsForContent:content Range:range];
        return  [[SyntaxMatchStore alloc] init];
    }
    else if([_include characterAtIndex:0]=='#') {
        NSString *str = [_include substringFromIndex:1];
        return [root parseResultsForRepoRule:str Content:content Range:range];
    }
    else {
        
        NSDictionary* bundle = [TMBundleSyntaxParser plistByName:_include];
        NSArray* extPatterns= [bundle objectForKey:@"patterns"];
        NSDictionary* extRepo = [bundle objectForKey:@"repository"];
        if (extPatterns) {
            id<SyntaxPatternsDelegate> sp = [root patternsForBundlePatterns:extPatterns Repository:extRepo];
            
            SyntaxMatchStore* extSt = [sp parseResultsForContent:content Range:range];
            NSLog(@"%@",extSt);
            return extSt;
        }
       
        return [[SyntaxMatchStore alloc] init];
    }
    
    return [[SyntaxMatchStore alloc] init];
}

- (id<SyntaxPatternsDelegate>)rootParent {
    id<SyntaxPatternsDelegate> pp = [_parent parent];
   // NSLog(@"include root search");
    if (!pp) {
        return _parent;
    }
    id<SyntaxPatternsDelegate> lp = pp;
    while (pp != nil) {
        lp = pp;
        //NSLog(@"%@",lp);
        pp = [pp parent];
    }
    //NSLog(@"include root found");
    return lp;
}
@end
