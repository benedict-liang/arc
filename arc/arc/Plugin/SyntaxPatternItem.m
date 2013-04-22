//
//  SyntaxPatternItem.m
//  arc
//
//  Created by omer iqbal on 23/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SyntaxPatternItem.h"

@implementation SyntaxPatternItem
- (id)initWithEmbedPatterns:(id<SyntaxPatternsDelegate>)embedP {
    _patterns = embedP;
    return self;
}
- (SyntaxMatchStore*)parseContent:(NSString *)content WithRange:(NSRange)range {
    return [_patterns parseResultsForContent:content Range:range];
}

@end
