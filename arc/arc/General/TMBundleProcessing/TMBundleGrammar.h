//
//  Grammar.h
//  arc
//
//  Created by Benedict Liang on 28/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMBundleGrammar : NSObject

- (id)initWithPlist:(NSDictionary*)plist;
- (id)initWithPlists:(NSArray*)pListsArray;

- (void)parseGrammar:(NSString*)key withValue:(id)value;

@end
