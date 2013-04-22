//
//  SyntaxSingleItem.h
//  arc
//
//  Created by omer iqbal on 22/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SyntaxItemProtocol.h"
@interface SyntaxSingleItem : NSObject <SyntaxItemProtocol>
@property NSString* match;
@property NSDictionary* captures;

- (id)initWithName:(NSString *)name Match:(NSString *)match Captures:(NSDictionary*)captures CapturableScopes:(NSArray*)cpS;

@end
