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
@property NSArray* syntaxOverlays;
@end
@implementation SyntaxPatterns

-(id<SyntaxPatternsDelegate>)patternsForBundlePatterns:(NSArray*)ps Repository:(NSDictionary*)repo {
    return [[SyntaxPatterns alloc] initWithBundlePatterns:ps Repository:repo];
}
- (id)initWithBundlePatterns:(NSArray *)bundlePatterns Repository:(NSDictionary *)repo{
    _parent = nil;
    _syntaxOverlays = [Constants syntaxOverlays];
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
- (id)initWithBundlePatterns:(NSArray *)bundlePatterns Parent:(SyntaxPatterns*)p {
    self = [self initWithBundlePatterns:bundlePatterns Repository:nil];
    _parent = p;
    return self;
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
            SyntaxPatterns* embed = [[SyntaxPatterns alloc] initWithBundlePatterns:embedPatterns Parent:self];
            item = [[SyntaxPairItem alloc] initWithBegin:begin End:end Name:name CPS:capturableScopes BeginCaptures:beginCaptures EndCaptures:endCaptures ContentName:contentName EmbedPatterns:embed];
        } else {
            item = [[SyntaxPairItem alloc] initWithBegin:begin End:end Name:name CPS:capturableScopes BeginCaptures:beginCaptures EndCaptures:endCaptures ContentName:contentName EmbedPatterns:nil];
        }
        
    }
    else if (embedPatterns) {
        SyntaxPatterns* embed = [[SyntaxPatterns alloc] initWithBundlePatterns:embedPatterns Parent:self];
        item = [[SyntaxPatternItem alloc] initWithEmbedPatterns:embed];
    }
    else if (include) {
        item = [[SyntaxIncludeItem alloc] initWithInclude:include Parent:self];
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
    for (id k in _repository) {
        id<SyntaxItemProtocol> syntaxItem = [_repository objectForKey:k];
        SyntaxMatchStore* res = [syntaxItem parseContent:content WithRange:range];
        [accum mergeWithStore:res];
    }
    return accum;
}


- (SyntaxMatchStore*)parseResultsForRepoRule:(NSString *)key
                                     Content:(NSString *)content
                                       Range:(NSRange)range
{
    id<SyntaxItemProtocol> rule = [_repository objectForKey:key];
    
    if (rule) {
        return [rule parseContent:content WithRange:range];
    }
    return nil;
}

- (SyntaxMatchStore*)forwardParseForContent:(NSString *)content Range:(NSRange)range {
    SyntaxMatchStore* accum = [[SyntaxMatchStore alloc] init];
    ScopeRange* min = [ScopeRange scope:@"" Range:NSMakeRange(content.length, 0) CPS:nil];
    NSRange residueRange = NSMakeRange(0, content.length);
    while (residueRange.location < content.length) {
        for (id<SyntaxItemProtocol> syntaxItem in _patterns) {
            ScopeRange* res = [syntaxItem forwardParse:content WithResidue:residueRange OverlayScopes:_syntaxOverlays];
            if (res) {
                min = [res minByRange:min];
            }
        }
       
        [accum addScopeRange:min];
        CFIndex minEnds = min.range.location + min.range.length+1;
        residueRange = NSMakeRange(minEnds, content.length - minEnds);
    }
    return accum;
}

@end
