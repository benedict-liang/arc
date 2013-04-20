//
//  FoldNode.h
//  arc
//
//  Created by omer iqbal on 17/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kRootNode,
    kChildNode
} FoldNodeType;

@interface FoldNode : NSObject <NSCopying>
@property (nonatomic, readonly) NSRange contentRange;
@property (nonatomic, readonly) NSRange startRange;
@property (nonatomic, readonly) NSRange endRange;
@property (nonatomic) FoldNodeType type;

- (id)initWithContentRange:(NSRange)cr
               startRange:(NSRange)sr
                 endRange:(NSRange)er;
- (id)initWithNode:(FoldNode *)node;
+ (NSArray *)sortNodeArray:(NSArray *)nodes;
@end
