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
    /*
        _patterns = @[
                  @{@"keyword": @{@"patterns": @[@"\\sif\\s", @"\\swhile\\s", @"@property", @"@interface", @"#import"],
                                  @"foreground": [UIColor redColor]}},
                  @{@"constants": @{@"patterns": @[@"void"],
                                    @"foreground": [UIColor blueColor]}},
                  @{@"parens": @{@"patterns": @[@"\\{", @"\\}", @"\\[", @"\\]",@"\\)",@"\\("],
                                 @"foreground": [UIColor brownColor]}}
                  ];
     */
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
- (void)styleOnRange:(NSRange)range fcolor:(UIColor*)fcolor {
    [_output setColor:[fcolor CGColor] OnRange:range];
}

-(void)iterPatternsAndApply {
    for (NSDictionary* apattern in _patterns) {
        for (id descriptor in apattern) {
            NSDictionary* record = [apattern objectForKey:descriptor];
            NSArray* regexes = [record objectForKey:@"patterns"];
            UIColor* color = [record objectForKey:@"foreground"];
            for (NSString* p in regexes) {
                NSArray* regexRanges = [self foundPattern:p];
                for (NSValue* v in regexRanges) {
                    NSRange range;
                    [v getValue:&range];
                    [self styleOnRange:range fcolor:color];
                }
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
