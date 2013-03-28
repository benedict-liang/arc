//
//  TMBundleSyntaxParser.m
//  arc
//
//  Created by Benedict Liang on 26/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "TMBundleSyntaxParser.h"

@implementation TMBundleSyntaxParser

+ (NSDictionary*)getPListContent:(NSString*)TMBundleName {
    NSBundle *mainBundle = [NSBundle mainBundle];
    //TODO: Get plists name from Syntaxes folder
    NSURL *syntaxFileURL = [mainBundle URLForResource:@"HTML.plist" withExtension:nil];
    NSDictionary *plist = [NSDictionary dictionaryWithContentsOfURL:syntaxFileURL];
    
    return plist;
}

+ (NSArray*)getKeyList:(NSString*)TMBundleName {
    NSDictionary *plist = [TMBundleSyntaxParser getPListContent:TMBundleName];
    return [plist allKeys];
}

+ (NSArray*)getPlistData:(NSString*)TMBundleName withSectionHeader:(NSString*)sectionHeader {
    NSDictionary *plist = [TMBundleSyntaxParser getPListContent:TMBundleName];
    return [plist objectForKey:sectionHeader];
}

@end
