//
//  SyntaxPatternItem.h
//  arc
//
//  Created by omer iqbal on 23/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SyntaxItemProtocol.h"
#import "SyntaxPatternsDelegate.h"
@interface SyntaxPatternItem : NSObject <SyntaxItemProtocol>
@property id<SyntaxPatternsDelegate> patterns;
- (id)initWithEmbedPatterns:(id<SyntaxPatternsDelegate>)embedP;

@end
