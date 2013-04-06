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

// returns a plist for a file extension
+ (NSDictionary*)plistForExt:(NSString *)fileExt;

// returns a plist by name, without extension
+ (NSDictionary*)plistByName:(NSString*)TMBundleName;

@end
