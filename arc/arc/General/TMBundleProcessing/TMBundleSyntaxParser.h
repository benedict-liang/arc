//
//  TMBundleSyntaxParser.h
//  arc
//
//  Created by Benedict Liang on 26/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMBundleGrammar.h"

@interface TMBundleSyntaxParser : NSObject

+ (NSArray*)getKeyList:(NSString*)TMBundleName;
+ (NSArray*)getPlistData:(NSString*)TMBundleName withSectionHeader:(NSString*)sectionHeader;
+ (NSArray*)getPatternsArray:(NSArray*)patternsSection;

@end
