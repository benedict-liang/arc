//
//  SyntaxIncludeItem.h
//  arc
//
//  Created by omer iqbal on 22/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SyntaxItemProtocol.h"
@interface SyntaxIncludeItem : NSObject <SyntaxItemProtocol>
@property NSString* include;
- (id)initWithInclude:(NSString*)i;

@end
