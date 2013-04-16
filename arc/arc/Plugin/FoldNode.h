//
//  FoldNode.h
//  arc
//
//  Created by omer iqbal on 17/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoldNode : NSObject

@property NSRange contentRange;
@property NSRange startRange;
@property NSRange endRange;

-(id)initWithContentRange:(NSRange)cr
               startRange:(NSRange)sr
                 endRange:(NSRange)er;

@end
