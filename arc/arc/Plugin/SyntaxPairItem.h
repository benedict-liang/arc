//
//  SyntaxPairItem.h
//  arc
//
//  Created by omer iqbal on 22/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SyntaxItemProtocol.h"
@class SyntaxPatterns;

@interface SyntaxPairItem : NSObject <SyntaxItemProtocol>
@property NSString* begin;
@property NSString* end;
@property NSDictionary* beginCaptures;
@property NSDictionary* endCaptures;
@property NSString* contentName;
@property SyntaxPatterns* patterns;

- (id)initWithBegin:(NSString*)begin
                End:(NSString*)end
               Name:(NSString*)name
                CPS:(NSArray*)cps
      BeginCaptures:(NSDictionary*)beginCaptures
        EndCaptures:(NSDictionary*)endCaptures
        ContentName:(NSString*)contentName
      EmbedPatterns:(SyntaxPatterns*)patterns;

@end
