//
//  FoldTree.m
//  arc
//
//  Created by omer iqbal on 13/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FoldTree.h"

@implementation FoldTree

- (id)initWithContentRange:(NSRange)range sortedRanges:(NSArray*)sa
{
    if (self = [super init]) {
        _contentRange = range;
        [self consWithSorted:sa];
    }
    return self;
}
- (id)initWithContentRange:(NSRange)range ranges:(NSArray*)ranges
{
    return [self initWithContentRange:range sortedRanges:[Utils sortRanges:ranges]];
}

- (void)consWithSorted:(NSArray*)sortedRanges {
    
    NSMutableArray *accum = [NSMutableArray array];
    NSRange r;
    NSRange elder;
    [(NSValue*)[sortedRanges objectAtIndex:0] getValue:&elder];
    
    for (NSValue* v in sortedRanges) {
        [v getValue:&r];
        if (NSEqualRanges(r, elder)) {
            // do nothing
        }
        else if ([Utils isSubsetOf:elder arg:r]) {
            [accum  addObject:v];
        }
        else {
            FoldTree* subTree = [[FoldTree alloc] initWithContentRange:elder sortedRanges:accum];
            [_children addObject:subTree];
            elder = r;
            [accum removeAllObjects];
        }

    }
}
-(NSString*)description {
    NSMutableString* str = [NSMutableString stringWithFormat:@"Node: %@ children=> \n",[NSValue value:&_contentRange withObjCType:@encode(NSRange)]];
    for (FoldTree* subTree in _children) {
        [str appendString:[subTree description]];
    }
    return str;
}

@end
