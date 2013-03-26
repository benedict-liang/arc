//
//  TMBundleSyntaxParser.m
//  arc
//
//  Created by Benedict Liang on 26/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "TMBundleSyntaxParser.h"

@implementation TMBundleSyntaxParser

- (NSDictionary*)getPListContent:(NSString*)TMBundleName {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *syntaxFileURL = [mainBundle URLForResource:@"HTML.plist" withExtension:nil];
    NSDictionary *plist = [NSDictionary dictionaryWithContentsOfURL:syntaxFileURL];
    
    return plist;
}

- (NSArray*)getFileTypes:(NSString*)TMBundleName {
    NSDictionary *plist = [self getPListContent:TMBundleName];
    NSArray *fileTypesArray = [plist objectForKey:@"fileTypes"];
    
    return fileTypesArray;
}

- (NSArray*)getFoldingMarkers:(NSString*)TMBundleName {
    
    
    return nil;
}

- (NSArray*)getFirstLineMatch:(NSString*)TMBundleName {
    NSDictionary *plist = [self getPListContent:TMBundleName];
    NSArray *firstLineMatch = [plist objectForKey:@"firstLineMatch"];
    
    return firstLineMatch;
}

- (NSArray*)getPatterns:(NSString*)TMBundleName {
    NSDictionary *plist = [self getPListContent:TMBundleName];
    NSArray *patternsArray = [plist objectForKey:@"patterns"];
    
    return patternsArray;
}

@end
