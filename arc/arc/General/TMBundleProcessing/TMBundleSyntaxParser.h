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

// Returns YES if tmbundle has file type in syntaxes.
+ (BOOL)canHandleFileType:(NSString*)fileExtension forTMBundle:(NSString*)TMBundleName;

// Returns a patterns array that is stripped of all unused keys/values,
// and is now only a level deep for each pattern group.
+ (NSArray*)getPatternsArrayForFileType:(NSString*)fileType;

// Returns a patterns array that is stripped of all unused keys/values,
// and is now only a level deep for each pattern group.
+ (NSArray*)getPatternsArray:(NSString*)TMBundleName;

//Returns a patterns array. Uses file Ext from cached BundleConf.plist
+ (NSArray*)patternsArrayForExt:(NSString *)fileExt;

@end
