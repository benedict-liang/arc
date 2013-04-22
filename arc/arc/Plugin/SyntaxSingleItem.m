//
//  SyntaxSingleItem.m
//  arc
//
//  Created by omer iqbal on 22/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SyntaxSingleItem.h"

@implementation SyntaxSingleItem
@synthesize name=_name, capturableScopes = _capturableScopes;

- (id)initWithName:(NSString *)name Match:(NSString *)match Captures:(NSDictionary*)captures CapturableScopes:(NSArray*)cpS{
    if (self = [super init]) {
        _name = name;
        _match = match;
        _capturableScopes = cpS;
        _captures = captures;
    }
    return self;
}
- (NSString *)description {
    return [NSString stringWithFormat:@"name: %@ match:%@ captures:%@",_name,_match, _captures];
}

- (SyntaxMatchStore*)parseContent:(NSString *)content WithRange:(NSRange)range {
    SyntaxMatchStore* store = [[SyntaxMatchStore alloc] init];
    if (_name) {
        NSArray* nameMatches = [RegexUtils foundPattern:_match capture:0 range:range content:content];
        SyntaxParserResult* result = [[SyntaxParserResult alloc] initWithScope:_name Ranges:nameMatches];
        [store addParserResult:result];
    }
    if (_captures) {
        for (NSNumber* k in _captures) {
            NSArray* captureMatches = [RegexUtils foundPattern:_match capture:[k intValue] range:range content:content];
            
        }
    }
}
@end
