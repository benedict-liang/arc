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

-(void)initPatternsAndTheme {
    
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
    for (NSDictionary* syntaxItem in _patterns) {
        NSString *name = [syntaxItem objectForKey:@"name"];
        NSString *match = [syntaxItem objectForKey:@"match"];
        NSArray *nameMatches = nil;
        if (name && match) {
            nameMatches = [self foundPattern:match];
            for (NSValue *v in nameMatches) {
                NSRange range;
                [v getValue:&range];
                NSDictionary* style = [(NSDictionary*)[_theme objectForKey:@"scopes"] objectForKey:name];
                if (style) {
                    [self styleOnRange:range fcolor:[style objectForKey:@"foreground"]];
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
