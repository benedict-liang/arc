//
//  SyntaxMatchStore.h
//  arc
//
//  Created by omer iqbal on 22/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SyntaxParserResult.h"
/*
 structure:
 { scope : {
        ranges: [NSRange]
        capturableScopes:[]
 }
 }
 */
@interface SyntaxMatchStore : NSObject

- (void)mergeWithStore:(SyntaxMatchStore*)store;
- (void)addParserResult:(SyntaxParserResult*)pres;
- (NSArray*)rangesForScope:(NSString*)scope;

@end
