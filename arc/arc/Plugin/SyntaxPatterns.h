//
//  SyntaxPatterns.h
//  arc
//
//  Created by omer iqbal on 22/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SyntaxItemProtocol.h"
#import "SyntaxPairItem.h"
#import "SyntaxSingleItem.h"

@interface SyntaxPatterns : NSObject
- (id)initWithBundlePatterns:(NSArray*)bundlePatterns;

@property NSArray* patterns;
@end
