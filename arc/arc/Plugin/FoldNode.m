//
//  FoldNode.m
//  arc
//
//  Created by omer iqbal on 17/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FoldNode.h"

@implementation FoldNode

- (id)initWithContentRange:(NSRange)cr startRange:(NSRange)sr endRange:(NSRange)er {
    if (self = [super init]) {
        _contentRange = cr;
        _startRange = sr;
        _endRange = er;
    }
    return self;
}

- (id)initWithNode:(FoldNode *)node {
    return [self initWithContentRange:node.contentRange startRange:node.startRange endRange:node.endRange];
}

- (id)copyWithZone:(NSZone *)zone {
    FoldNode* copy = [[FoldNode alloc] initWithNode:self];
    return copy;
}

+ (NSArray*)sortNodeArray:(NSArray*)nodes {
    //ASSUMES: ranges are either non intersecting, or subsets
    //Above holds true for foldable code blocks
    NSMutableArray* sortedRanges = [NSMutableArray arrayWithArray:nodes];
    [sortedRanges sortUsingComparator:^NSComparisonResult(FoldNode* n1, FoldNode* n2){
        NSRange r1 = n1.contentRange;
        NSRange r2 = n2.contentRange;
        int r1Ends = r1.location + r1.length;
        int r2Ends = r2.location + r2.length;
        //r1 dominates
        if (r1.location < r2.location && r1Ends > r2Ends) {
            return NSOrderedAscending;
            //r2 dominates
        } else if (r1.location > r2.location && r1Ends < r2Ends) {
            return NSOrderedDescending;
        } else {
            //don't care about other cases
            return NSOrderedSame;
        }
    }];
    return sortedRanges;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"cR: %d %d sR: %d %d eR:%d %d",_contentRange.location,_contentRange.length,_startRange.location,_startRange.length, _endRange.location, _endRange.length];
}
@end
