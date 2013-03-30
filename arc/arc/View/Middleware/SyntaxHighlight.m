//
//  SyntaxHighlight.m
//  arc
//
//  Created by omer iqbal on 28/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SyntaxHighlight.h"
#import "ArcAttributedString.h"

@implementation SyntaxHighlight

+ (void)arcAttributedString:(ArcAttributedString *)arcAttributedString OfFile:(File *)file
{
    SyntaxHighlight *sh = [[self alloc] init];
    [sh execOn:arcAttributedString FromFile:file];
}

- (void)initPatternsAndTheme {
    
    NSArray *patternsSection = [TMBundleSyntaxParser getPlistData:@"html.tmbundle" withSectionHeader:@"patterns"];
    _patterns = [TMBundleSyntaxParser getPatternsArray:patternsSection];
    _theme = [TMBundleThemeHandler produceStylesWithTheme:nil];
    NSLog(@"patterns array: %@", _patterns);
}
- (NSArray*)foundPattern:(NSString*)p {
    NSError *error = NULL;
    NSMutableArray* results = [[NSMutableArray alloc] init];
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:p
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
    NSArray* matches = [regex matchesInString:_content options:0 range:NSMakeRange(0, [_content length])];
    
    for (NSTextCheckingResult *match in matches) {
        NSRange range = [match range];
        [results addObject:[NSValue value:&range withObjCType:@encode(NSRange)]];
    }
    return results;
}
- (NSArray*)foundPattern:(NSString*)p capture:(int)c {
    NSError *error = NULL;
    NSMutableArray* results = [[NSMutableArray alloc] init];
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:p
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
    NSArray* matches = [regex matchesInString:_content options:0 range:NSMakeRange(0, [_content length])];
    
    for (NSTextCheckingResult *match in matches) {
        NSRange range = [match rangeAtIndex:c];
        [results addObject:[NSValue value:&range withObjCType:@encode(NSRange)]];
    }
    return results;
}
- (void)styleOnRange:(NSRange)range fcolor:(UIColor*)fcolor {
    [_output setColor:[fcolor CGColor] OnRange:range];
}

- (void)applyStyleToScope:(NSString*)name range:(NSRange)range {
    NSDictionary* style = [(NSDictionary*)[_theme objectForKey:@"scopes"] objectForKey:name];
    if (style) {
        [self styleOnRange:range fcolor:[style objectForKey:@"foreground"]];
    }
}
- (void)applyStyleToCaptures:(NSArray*)captures pattern:(NSString*)match {
    NSArray *captureMatches = nil;
    for (int i = 0; i < [captures count]; i++) {
        captureMatches = [self foundPattern:match capture:i];
        for (NSValue *v in captureMatches) {
            NSRange range;
            [v getValue:&range];
            [self applyStyleToScope:[captures objectAtIndex:i] range:range];
        }
    }
}
-(void)iterPatternsAndApply {
    for (NSDictionary* syntaxItem in _patterns) {
        NSString *name = [syntaxItem objectForKey:@"name"];
        NSString *match = [syntaxItem objectForKey:@"match"];
        NSString *begin = [syntaxItem objectForKey:@"begin"];
        NSArray *beginCaptures = [syntaxItem objectForKey:@"beginCaptures"];
        NSString *end = [syntaxItem objectForKey:@"end"];
        NSArray *endCaptures = [syntaxItem objectForKey:@"endCaptures"];
        NSArray *captures = [syntaxItem objectForKey:@"captures"];
        
        NSArray *nameMatches = nil;
        NSArray *captureMatches = nil;
        //case name, match
        if (name && match) {
            nameMatches = [self foundPattern:match];
            for (NSValue *v in nameMatches) {
                NSRange range;
                [v getValue:&range];
                [self applyStyleToScope:name range:range];
            }
        }
        if (captures && match) {
            [self applyStyleToCaptures:captures pattern:match];
        }
        if (beginCaptures && begin) {
            [self applyStyleToCaptures:beginCaptures pattern:begin];
        }
        if (endCaptures && end) {
            [self applyStyleToCaptures:endCaptures pattern:end];
        }
        if (name && begin && end) {
            NSArray *begins = [self foundPattern:begin];
            NSArray *ends = [self foundPattern:end];
            if ([begins count] == [ends count]) {
                for (int i =0; i < [begins count]; i++) {
                    NSRange brange;
                    NSRange erange;
                    NSValue *v1 = [begins objectAtIndex:i];
                    [v1 getValue:&brange];
                    NSValue *v2 = [ends objectAtIndex:i];
                    [v2 getValue:&erange];
                    NSRange blockRange = {brange.location, brange.location - (erange.location + erange.length)};
                    [self applyStyleToScope:name range:blockRange];
                }
            } else {
                NSLog(@"blocks don't match");
            }
        }
    }
}
- (void)execOn:(ArcAttributedString *)arcAttributedString FromFile:(File *)file {
    _output = arcAttributedString;
    [self initPatternsAndTheme];
    _content = [file contents];
    [self iterPatternsAndApply];
}
@end
