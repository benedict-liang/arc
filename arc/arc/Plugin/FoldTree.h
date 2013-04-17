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

@interface FoldTree : NSObject

@property NSMutableArray* children;
@property FoldNode* node;

- (id)initWithNodes:(NSArray*)nodes RootRange:(NSRange)range;

-(NSRange)lowestNodeWithIndex:(CFIndex)index;

-(NSRange)lowestNodeWithFoldStartIndex:(CFIndex)index;

-(NSArray*)foldStartRanges;
@end
