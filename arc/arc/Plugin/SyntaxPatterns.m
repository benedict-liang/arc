//
//  SyntaxPatterns.m
//  arc
//
//  Created by omer iqbal on 22/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SyntaxPatterns.h"
@interface SyntaxPatterns ()

@end
@implementation SyntaxPatterns

- (id)initWithBundlePatterns:(NSArray *)bundlePatterns {
    NSMutableArray* accum = [NSMutableArray array];
    
    for (NSDictionary* syntaxItem in bundlePatterns) {
        id<SyntaxItemProtocol> item = nil;
        NSString *name = [syntaxItem objectForKey:@"name"];
        NSString *match = [syntaxItem objectForKey:@"match"];
        NSString *begin = [syntaxItem objectForKey:@"begin"];
        NSDictionary *beginCaptures = [syntaxItem objectForKey:@"beginCaptures"];
        NSString *end = [syntaxItem objectForKey:@"end"];
        NSDictionary *endCaptures = [syntaxItem objectForKey:@"endCaptures"];
        NSDictionary *captures = [syntaxItem objectForKey:@"captures"];
        NSString *include = [syntaxItem objectForKey:@"include"];
        NSArray* embedPatterns = [syntaxItem objectForKey:@"patterns"];
        NSArray* capturableScopes = [syntaxItem objectForKey:@"capturableScopes"];
        
        //possible scenarios with SyntaxSingleItem
        if (name && match && captures) {
           item = [[SyntaxSingleItem alloc] initWithName:name Match:match Captures:captures CapturableScopes:capturableScopes];
        }
        else if (name && match && !captures)
        {
            item = [[SyntaxSingleItem alloc] initWithName:name Match:match Captures:nil CapturableScopes:capturableScopes];
        }
        else if (!name && match && captures)
        {
            item = [[SyntaxSingleItem alloc] initWithName:nil Match:match Captures:captures CapturableScopes:capturableScopes];
        }
        
        else if (begin && end)
        {
            
        }
        
        
    }
}
@end
