//
//  ScopeRange.h
//  arc
//
//  Created by omer iqbal on 24/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScopeRange : NSObject
@property NSRange range;
@property NSString* scope;
- (id)initWithScope:(NSString*)s Range:(NSRange)r;
+ (ScopeRange*)scope:(NSString*)s Range:(NSRange)r;

@end
