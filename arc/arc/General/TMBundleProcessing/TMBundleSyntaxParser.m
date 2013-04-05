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
//    NSURL *syntaxFileURL = [mainBundle URLForResource:@"Python.tmLanguage" withExtension:nil];
//    NSDictionary *plist = [NSDictionary dictionaryWithContentsOfURL:syntaxFileURL];
//    
//    [plistArray addObject:plist];
    
    NSURL *syntaxFileURL1 = [mainBundle URLForResource:TMBundleName withExtension:nil];
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

+ (BOOL)canHandleFileType:(NSString*)fileExtension forTMBundle:(NSString*)TMBundleName {
    //remove initial dot character
    if ([fileExtension characterAtIndex:0] == '.') {
        fileExtension = [fileExtension substringFromIndex:1];
    }
    
    NSArray *plistsArray = [TMBundleSyntaxParser getSyntaxPLists:TMBundleName];
    
    for (NSDictionary *plist in plistsArray) {
        NSArray *fileTypes = [plist objectForKey:@"fileTypes"];
        
        if (fileTypes != nil) {
            if ([fileTypes containsObject:fileExtension]) {
                return YES;
            }
        }
    }
    
    return NO;
}

// Returns a patterns array that is stripped of all unused keys/values,
// and is now only a level deep for each pattern group.
+ (NSArray*)getPatternsArray:(NSString*)TMBundleName {
    NSMutableArray *patternsArray = [[NSMutableArray alloc] init];
    
    NSArray *plistsArray = [TMBundleSyntaxParser getSyntaxPLists:TMBundleName];
    
    TMBundleGrammar *grammar = [[TMBundleGrammar alloc] initWithPlists:plistsArray];
    
    // TODO: Handle conditions to parse multiple plists, and combine the results
    NSDictionary *plist = [plistsArray objectAtIndex:0];
    id patternsValue = [plist objectForKey:@"patterns"];
    if (patternsValue != nil) {
        NSArray *test = [grammar parseGrammar:@"patterns" withValue:patternsValue];
        [patternsArray addObjectsFromArray:test];
    }

    return [NSArray arrayWithArray:patternsArray];
}

@end
