//
//  FoldTree.m
//  arc
//
//  Created by omer iqbal on 13/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FoldTree.h"

@implementation FoldTree

- (id)initWithSortedNodes:(NSArray*)sn Node:(FoldNode*)node
{
    if (self = [super init]) {
        _node = node;
        _children = [NSMutableArray array];
        [self consWithSorted:sn];
    }
    return self;
}
- (id)initWithNodes:(NSArray *)nodes RootRange:(NSRange)range
{
    RootFoldNode* root = [[RootFoldNode alloc] initWithContentRange:range];
    
    return [self initWithSortedNodes:[FoldNode sortNodeArray:nodes] Node:root];
}

- (void)consWithSorted:(NSArray*)sortedNodes {
    
    NSMutableArray *accum = [NSMutableArray array];
    FoldNode* elder;

    if (sortedNodes.count > 0) {
        elder = [sortedNodes objectAtIndex:0];
        
        for (int i = 1; i < sortedNodes.count; i++) {
            FoldNode* node = [sortedNodes objectAtIndex:i];
            
            if ([Utils isSubsetOf:elder.contentRange arg:node.contentRange]) {
                [accum  addObject:node];
            }
            else {
                
                FoldTree* subTree = [[FoldTree alloc] initWithSortedNodes:[[NSArray alloc] initWithArray:accum copyItems:YES]
                                                                     Node:elder];
                [_children addObject:subTree];
                elder = node;
                [accum removeAllObjects];
            }

        }
        FoldTree* last = [[FoldTree alloc] initWithSortedNodes:[[NSArray alloc] initWithArray:accum copyItems:YES]
                                                          Node:elder];

        [_children addObject:last];
    
    }
}

-(NSString*)description {
    NSMutableString* str = [NSMutableString stringWithFormat:@"Node: %@ children=> { \n",_node];
    for (FoldTree* subTree in _children) {
        [str appendString:@"    "];
        [str appendString:[subTree description]];
        [str appendString:@"\n"];
    }
    [str appendString:@" } \n"];
    return str;
}


-(NSRange)lowestNodeWithIndex:(CFIndex)index {
    if ([Utils isContainedByRange:_node.contentRange Index:index]) {
            NSRange leafRange = _node.contentRange;
            for (FoldTree* subTree in _children) {
                NSRange childRange = [subTree lowestNodeWithIndex:index];
                if (childRange.location!= NSNotFound) {
                    leafRange = childRange;
                }
            }
            return leafRange;

    } else {
        return NSMakeRange(NSNotFound, 0);
    }
}

-(NSRange)lowestNodeWithFoldStartIndex:(CFIndex)index {
    if ([Utils isContainedByRange:_node.startRange Index:index] ) {
        NSRange leafRange = _node.contentRange;
        for (FoldTree* subTree in _children) {
            NSRange childRange = [subTree lowestNodeWithFoldStartIndex:index];
            if (childRange.location!= NSNotFound) {
                leafRange = childRange;
            }
        }
        return leafRange;
        
    } else {
        return NSMakeRange(NSNotFound, 0);
    }
}

-(NSArray*)foldStartRanges {
    NSMutableArray* accum = [NSMutableArray array];
    [accum addObject:[Utils valueFromRange:_node.startRange]];
    for (FoldTree* subtree in _children) {
        [accum addObjectsFromArray:[subtree foldStartRanges]];
    }
    return accum;
}
@end
