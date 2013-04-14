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
        _children = [NSMutableArray array];
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
    //NSLog(@"sortedRanges: %@",sortedRanges);
    if (sortedRanges.count > 0) {
        [(NSValue*)[sortedRanges objectAtIndex:0] getValue:&elder];
        
        for (int i = 1; i < sortedRanges.count; i++) {
            NSValue* value = [sortedRanges objectAtIndex:i];
            [value getValue:&r];
            if ([Utils isSubsetOf:elder arg:r]) {
                [accum  addObject:value];
            }
            else {
                
                FoldTree* subTree = [[FoldTree alloc] initWithContentRange:elder sortedRanges:[FoldTree rangeArrayCopy:accum]];
                [_children addObject:subTree];
                elder = r;
                [accum removeAllObjects];
            }

        }
        FoldTree* last = [[FoldTree alloc] initWithContentRange:elder ranges:[FoldTree rangeArrayCopy:accum]];
        [_children addObject:last];
    
    }
}

-(NSString*)description {
    NSMutableString* str = [NSMutableString stringWithFormat:@"Node: %@ children=> { \n",[NSValue value:&_contentRange withObjCType:@encode(NSRange)]];
    for (FoldTree* subTree in _children) {
        [str appendString:@"    "];
        [str appendString:[subTree description]];
        [str appendString:@"\n"];
    }
    [str appendString:@" } \n"];
    return str;
}

+(NSArray*)rangeArrayCopy:(NSArray*)arr {
    NSMutableArray *tmp = [NSMutableArray array];
    for (NSValue *v in arr) {
        NSRange range;
        [v getValue:&range];
        NSValue *m = [NSValue value:&range withObjCType:@encode(NSRange)];
        [tmp addObject:m];
    }
    return tmp;
}
@end
