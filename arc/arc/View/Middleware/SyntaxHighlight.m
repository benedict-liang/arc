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
    
    _patterns = [TMBundleSyntaxParser getPatternsArray:@"javascript.tmbundle"];
    _theme = [TMBundleThemeHandler produceStylesWithTheme:nil];
    NSLog(@"patterns array: %@", _patterns);
}
- (NSArray*)foundPattern:(NSString*)p range:(NSRange)r {
    NSError *error = NULL;
    NSMutableArray* results = [[NSMutableArray alloc] init];
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:p
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
    NSArray* matches = [regex matchesInString:_content options:0 range:r];
    
    for (NSTextCheckingResult *match in matches) {
        NSRange range = [match range];
        [results addObject:[NSValue value:&range withObjCType:@encode(NSRange)]];
    }
    return results;
}
- (NSRange)findFirstPattern:(NSString*)p range:(NSRange)range {
    NSError *error = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:p
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
    NSTextCheckingResult *res = [regex firstMatchInString:_content options:0 range:range];
    if (res) {
        return [res range];
    } else {
        return NSMakeRange(0, 0);
    }
}
- (NSArray*)foundPattern:(NSString*)p capture:(int)c range:(NSRange)r {
    NSError *error = NULL;
    NSMutableArray* results = [[NSMutableArray alloc] init];
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:p
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
    NSArray* matches = [regex matchesInString:_content options:0 range:r];
    
    for (NSTextCheckingResult *match in matches) {
        NSRange range = [match rangeAtIndex:c];
        [results addObject:[NSValue value:&range withObjCType:@encode(NSRange)]];
    }
    return results;
}
- (void)styleOnRange:(NSRange)range fcolor:(UIColor*)fcolor {
    [_output setColor:[fcolor CGColor] OnRange:range];
}

- (NSArray*)capturableScopes:(NSString*)name {
    NSArray *splitScopes = [name componentsSeparatedByString:@"."];
    NSString *accum = nil;
    NSMutableArray *scopes = [NSMutableArray array];
    
    for (NSString*  s in splitScopes) {
        if (!accum) {
            accum = s;
        } else {
            accum = [accum stringByAppendingFormat:@".%@",s];
        }
        [scopes addObject:accum];
    }
    return scopes;
}

- (void)applyStyleToScope:(NSString*)name range:(NSRange)range {
    
    NSArray* capturableScopes = [self capturableScopes:name];
    for (NSString *s in capturableScopes) {
        NSDictionary* style = [(NSDictionary*)[_theme objectForKey:@"scopes"] objectForKey:s];
        UIColor *fg = nil;
        if (style) {
            fg = [style objectForKey:@"foreground"];
        }
        if (fg) {
            [self styleOnRange:range fcolor:fg];
        }
    }
}

- (void)applyStyleToCaptures:(NSArray*)captures pattern:(NSString*)match range:(NSRange)r {
    NSArray *captureMatches = nil;
    for (int i = 0; i < [captures count]; i++) {
        captureMatches = [self foundPattern:match capture:i range:r];
        for (NSValue *v in captureMatches) {
            NSRange range;
            [v getValue:&range];
            [self applyStyleToScope:[captures objectAtIndex:i] range:range];
        }
    }
}
-(void)iterPatternsAndApplyForRange:(NSRange)contentRange patterns:(NSArray*)patterns {
    for (NSDictionary* syntaxItem in patterns) {
        NSString *name = [syntaxItem objectForKey:@"name"];
        NSString *match = [syntaxItem objectForKey:@"match"];
        NSString *begin = [syntaxItem objectForKey:@"begin"];
        NSArray *beginCaptures = [syntaxItem objectForKey:@"beginCaptures"];
        NSString *end = [syntaxItem objectForKey:@"end"];
        NSArray *endCaptures = [syntaxItem objectForKey:@"endCaptures"];
        NSArray *captures = [syntaxItem objectForKey:@"captures"];
        NSArray *embedPatterns = [syntaxItem objectForKey:@"patterns"];
        
        NSArray *nameMatches = nil;
        //case name, match
        if (name && match) {
            nameMatches = [self foundPattern:match range:contentRange];
            for (NSValue *v in nameMatches) {
                NSRange range;
                [v getValue:&range];
                [self applyStyleToScope:name range:range];
            }
        }
        if (captures && match) {
            [self applyStyleToCaptures:captures pattern:match range:contentRange];
        }
        if (beginCaptures && begin) {
            [self applyStyleToCaptures:beginCaptures pattern:begin range:contentRange];
        }
        if (endCaptures && end) {
            [self applyStyleToCaptures:endCaptures pattern:end range:contentRange];
        }
        //matching blocks
        if (name && begin && end) {
            
            NSRange brange = [self findFirstPattern:begin range:NSMakeRange(0, [_content length])];
            NSRange erange = NSMakeRange(0, 0);
            
            while (brange.length != 0 && erange.location + erange.length < [_content length] ) {
                
                int bEnds = brange.location + brange.length;
                erange = [self findFirstPattern:end range:NSMakeRange(bEnds, [_content length] - bEnds)];
                int eEnds = erange.location + erange.length;
                
                if (embedPatterns) {
                    
                    [self iterPatternsAndApplyForRange:NSMakeRange(brange.location, eEnds) patterns:embedPatterns];
                }
                
                if (brange.length > 0 && erange.length > 0 && eEnds <= [_content length]) {
                    [self applyStyleToScope:name range:NSMakeRange(brange.location, eEnds - brange.location)];
                }
                brange = [self findFirstPattern:begin range:NSMakeRange(eEnds, [_content length] - eEnds )];
           }
            
        }
    
    }
}
- (void)execOn:(ArcAttributedString *)arcAttributedString FromFile:(File *)file {
    _output = arcAttributedString;
    [self initPatternsAndTheme];
    _content = [file contents];
    [self iterPatternsAndApplyForRange:NSMakeRange(0, [_content length]) patterns:_patterns];
}
@end
