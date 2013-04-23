//
//  SyntaxItemProtocol.h
//  arc
//
//  Created by omer iqbal on 22/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SyntaxMatchStore.h"
#import "ScopeRange.h"
#import "RegexUtils.h"
@protocol SyntaxItemProtocol <NSObject>
- (SyntaxMatchStore*)parseContent:(NSString*)content WithRange:(NSRange)range;
- (ScopeRange*)forwardParse:(NSString*)content WithResidue:(NSRange)range OverlayScopes:(NSArray*)overlays;

@optional
@property NSString* name;
@property NSArray* capturableScopes;
@end
