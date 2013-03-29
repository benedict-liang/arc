//
//  TMBundleSyntaxParser.m
//  arc
//
//  Created by Benedict Liang on 26/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "TMBundleSyntaxParser.h"

@implementation TMBundleSyntaxParser

+ (NSArray*)getSyntaxPLists:(NSString*)TMBundleName {
    NSMutableArray *plistArray = [[NSMutableArray alloc] init];
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    //TODO: Get plists name from Syntaxes folder
    NSURL *syntaxFileURL = [mainBundle URLForResource:@"JavaScript.plist" withExtension:nil];
    NSDictionary *plist = [NSDictionary dictionaryWithContentsOfURL:syntaxFileURL];
    
    [plistArray addObject:plist];
    
    NSURL *syntaxFileURL1 = [mainBundle URLForResource:@"Regular Expressions (JavaScript).tmLanguage" withExtension:nil];
    NSDictionary *plist1 = [NSDictionary dictionaryWithContentsOfURL:syntaxFileURL1];

    [plistArray addObject:plist1];
    
    return [NSArray arrayWithArray:plistArray];
}

+ (NSArray*)getKeyList:(NSString*)TMBundleName {
    NSDictionary *plist = (NSDictionary*)[[TMBundleSyntaxParser getSyntaxPLists:TMBundleName] objectAtIndex:0];
    return [plist allKeys];
}

+ (NSArray*)getPlistData:(NSString*)TMBundleName withSectionHeader:(NSString*)sectionHeader {
    NSDictionary *plist = (NSDictionary*)[[TMBundleSyntaxParser getSyntaxPLists:TMBundleName] objectAtIndex:0];
    return [plist objectForKey:sectionHeader];
}

+ (NSArray*)getPatternsArray:(NSArray*)patternsSection {
    NSMutableArray *patternsArray = [[NSMutableArray alloc] init];
    
    //TODO: syntax name is for testing only
    NSArray *plistsArray = [TMBundleSyntaxParser getSyntaxPLists:@"name"];
    
    TMBundleGrammar *grammar = [[TMBundleGrammar alloc] initWithPlists:plistsArray];
    
    for (NSDictionary *syntaxItem in patternsSection) {
        NSMutableDictionary *processedSyntaxItem = [[NSMutableDictionary alloc] init];
        for (NSString *key in [syntaxItem allKeys]) {
            id result = [grammar parseGrammar:key withValue:[syntaxItem objectForKey:key]];
            if (result != nil) {
                [processedSyntaxItem setObject:result forKey:key];
            }
        }
        
        if ([processedSyntaxItem count] != 0) {
            [patternsArray addObject:[NSDictionary dictionaryWithDictionary:processedSyntaxItem]];
        }
    }
    
    NSLog(@"%@", patternsArray);
    
    return nil;
}

@end
