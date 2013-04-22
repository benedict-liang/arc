//
//  SyntaxPairItem.m
//  arc
//
//  Created by omer iqbal on 22/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SyntaxPairItem.h"

@implementation SyntaxPairItem
@synthesize name = _name, capturableScopes = _capturableScopes;

-(id)initWithBegin:(NSString *)begin End:(NSString *)end Name:(NSString *)name CPS:(NSArray *)cps BeginCaptures:(NSDictionary *)beginCaptures EndCaptures:(NSDictionary *)endCaptures ContentName:(NSString *)contentName EmbedPatterns:(SyntaxPatterns *)patterns{
    if (self = [super init]) {
        _begin = begin;
        _end = end;
        _name = name;
        _capturableScopes = cps;
        _beginCaptures = beginCaptures;
        _endCaptures = endCaptures;
        _contentName = contentName;
        _patterns = patterns;
    }
    return self;
}

-(SyntaxMatchStore*)parseContent:(NSString *)content WithRange:(NSRange)range {
    return [[SyntaxMatchStore alloc] init];
}
@end
