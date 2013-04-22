//
//  SyntaxPatterns.m
//  arc
//
//  Created by omer iqbal on 22/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

/*
 Axioms:
 1. embedPatterns only in SyntaxPairItem
 2. include occurs by itself
 */
#import "SyntaxPatterns.h"
@interface SyntaxPatterns ()

@end
@implementation SyntaxPatterns

- (id)initWithBundlePatterns:(NSArray *)bundlePatterns Repository:(NSDictionary *)repo{
    NSMutableArray* accum = [NSMutableArray array];
    
    for (NSDictionary* syntaxItem in bundlePatterns) {
        id<SyntaxItemProtocol> processedItem = [self syntaxItemForDict:syntaxItem];
        if (processedItem) {
            [accum addObject:processedItem];
        }
    
    }
    _patterns = accum;
    NSMutableDictionary* repoAccum = [NSMutableDictionary dictionary];
    for (id k in repo) {
        NSDictionary* syntaxItem = [repo objectForKey:k];
        id<SyntaxItemProtocol> processedItem = [self syntaxItemForDict:syntaxItem];
        if (processedItem) {
            [repoAccum setObject:processedItem forKey:k];
        }
    }
    _repository = repoAccum;
    return self;
}
- (id)initWithBundlePatterns:(NSArray *)bundlePatterns {
    return [self initWithBundlePatterns:bundlePatterns Repository:nil];
}
- (id<SyntaxItemProtocol>)syntaxItemForDict:(NSDictionary*)syntaxItem {
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
    NSString* contentName = [syntaxItem objectForKey:@"contentName"];
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
        if (embedPatterns) {
            SyntaxPatterns* embed = [[SyntaxPatterns alloc] initWithBundlePatterns:embedPatterns];
            item = [[SyntaxPairItem alloc] initWithBegin:begin End:end Name:name CPS:capturableScopes BeginCaptures:beginCaptures EndCaptures:endCaptures ContentName:contentName EmbedPatterns:embed];
        } else {
            item = [[SyntaxPairItem alloc] initWithBegin:begin End:end Name:name CPS:capturableScopes BeginCaptures:beginCaptures EndCaptures:endCaptures ContentName:contentName EmbedPatterns:nil];
        }
        
    }
    else if (include) {
        item = [[SyntaxIncludeItem alloc] initWithInclude:include];
    }
    return item;
}

- (NSString*) description {
    return [NSString stringWithFormat:@"patterns:%@\n repo:%@",_patterns, _repository];
}

- (SyntaxMatchStore*)parseResultsForContent:(NSString*)content Range:(NSRange)range {
    SyntaxMatchStore* accum = [[SyntaxMatchStore alloc] init];
    for (id<SyntaxItemProtocol> syntaxItem in _patterns) {
        SyntaxMatchStore* res = [syntaxItem parseContent:content WithRange:range];
        [accum mergeWithStore:res];
    }
    return accum;
}

@end
