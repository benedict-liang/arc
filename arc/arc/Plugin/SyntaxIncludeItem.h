//
//  SyntaxIncludeItem.h
//  arc
//
//  Created by omer iqbal on 22/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SyntaxItemProtocol.h"
#import "SyntaxPatternsDelegate.h"
#import "TMBundleHeader.h"
@interface SyntaxIncludeItem : NSObject <SyntaxItemProtocol>
@property NSString* include;
@property id<SyntaxPatternsDelegate> parent;
- (id)initWithInclude:(NSString*)i Parent:(id<SyntaxPatternsDelegate>)p;

@end
