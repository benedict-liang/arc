//
//  SyntaxPairItem.h
//  arc
//
//  Created by omer iqbal on 22/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SyntaxPairItem : NSObject
@property NSString* begin;
@property NSString* end;
@property NSDictionary* beginCaptures;
@property NSDictionary* endCaptures;
@property NSString* contentName;

@end
