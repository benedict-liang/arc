//
//  SyntaxParserResult.h
//  arc
//
//  Created by omer iqbal on 22/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SyntaxParserResult : NSObject
@property NSString* scope;
@property NSMutableArray* ranges;
@property NSArray* capturableScopes;

-(id)initWithScope:(NSString*)scope Ranges:(NSArray*)ranges CPS:(NSArray*)cps;


@end
