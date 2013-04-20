//
//  FoldTree.h
//  arc
//
//  Created by omer iqbal on 13/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utils.h"
#import "FoldNode.h"
#import "RootFoldNode.h"
#import "CodeViewLine.h"

@interface FoldTree : NSObject
@property (nonatomic, strong) NSMutableArray* children;
@property (nonatomic, strong) FoldNode* node;

- (id)initWithNodes:(NSArray *)nodes RootRange:(NSRange)range;
- (FoldNode *)lowestNodeWithIndex:(CFIndex)index;
- (NSRange)lowestNodeWithFoldStartIndex:(CFIndex)index;
- (NSArray *)foldStartRanges;
- (NSDictionary *)collapsibleLinesForIndex:(CFIndex)index
                                 WithLines:(NSArray *)lines;
@end
