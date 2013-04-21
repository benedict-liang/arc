//
//  OverlapPeekResult.m
//  arc
//
//  Created by omer iqbal on 22/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "OverlapPeekResult.h"

@implementation OverlapPeekResult

- (id)initWithBrange:(NSRange)br Erange:(NSRange)er Syntax:(NSDictionary*)si {
    _beginRange = br;
    _endRange = er;
    _syntaxItem = si;
    return self;
}
+ (OverlapPeekResult*)resultWithBeginRange:(NSRange)br EndRange:(NSRange)er SyntaxItem:(NSDictionary *)si {
    return [[OverlapPeekResult alloc] initWithBrange:br Erange:er Syntax:si];
}
- (NSString*)description {
    return [NSString stringWithFormat:@"beginRange:%@ \nendRange:%@\n syntaxItem:%@",[Utils valueFromRange:_beginRange],[Utils valueFromRange:_endRange],_syntaxItem];
}
@end
