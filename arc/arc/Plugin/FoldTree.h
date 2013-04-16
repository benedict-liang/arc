//
//  FoldTree.h
//  arc
//
//  Created by omer iqbal on 13/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Utils.h"

@interface FoldTree : NSObject

@property NSMutableArray* children;
@property NSRange contentRange;
@property NSString* foldStart;
@property NSString* foldEnd;
@property NSRange startRange;
@property NSRange endRange;

- (id)initWithContentRange:(NSRange)range
                    ranges:(NSArray*)ranges
                    starts:(NSArray*)starts
                      ends:(NSArray*)ends;
-(NSRange)lowestNodeWithIndex:(CFIndex)index;
@end
