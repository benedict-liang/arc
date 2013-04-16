//
//  FoldNode.h
//  arc
//
//  Created by omer iqbal on 17/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoldNode : NSObject <NSCopying>

@property(readonly) NSRange contentRange;
@property(readonly) NSRange startRange;
@property(readonly) NSRange endRange;

-(id)initWithContentRange:(NSRange)cr
               startRange:(NSRange)sr
                 endRange:(NSRange)er;

-(id)initWithNode:(FoldNode*)node;
+ (NSArray*)sortNodeArray:(NSArray*)nodes;
@end
