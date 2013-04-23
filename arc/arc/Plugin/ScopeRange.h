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
@property NSArray* capturableScopes;
- (id)initWithScope:(NSString*)s Range:(NSRange)r CPS:(NSArray*)cps;
+ (ScopeRange*)scope:(NSString*)s Range:(NSRange)r CPS:(NSArray*)cps;
- (ScopeRange*)minByRange:(ScopeRange*)s1;

@end
