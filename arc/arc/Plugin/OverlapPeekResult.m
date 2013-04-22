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
    _type = kSyntaxPair;
    return self;
}
- (id)initWithMatch:(NSRange)m Syntax:(NSDictionary*)si {
    _matchRange = m;
    _syntaxItem = si;
    _type = kSyntaxSingle;
    return self;
}
+ (OverlapPeekResult*)resultWithBeginRange:(NSRange)br EndRange:(NSRange)er SyntaxItem:(NSDictionary *)si {
    return [[OverlapPeekResult alloc] initWithBrange:br Erange:er Syntax:si];
}

+ (OverlapPeekResult*)resultWithMatchRange:(NSRange)m SyntaxItem:(NSDictionary*)si {
    return [[OverlapPeekResult alloc] initWithMatch:m Syntax:si];
}
- (NSString*)description {
    return [NSString stringWithFormat:@"matchRange:%@ \n beginRange:%@ \nendRange:%@\n",[Utils valueFromRange:_matchRange],[Utils valueFromRange:_beginRange],[Utils valueFromRange:_endRange]];
}
@end
