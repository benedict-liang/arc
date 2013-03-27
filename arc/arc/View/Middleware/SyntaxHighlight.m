//
//  SyntaxHighlight.m
//  arc
//
//  Created by omer iqbal on 28/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SyntaxHighlight.h"

@implementation SyntaxHighlight
-(void)initPatterns {
    _patterns = @[
    @{@"keyword": @{@"patterns": @[@"if", @"while", @"\\{", @"\\}", @"\\[", @"\\]", @"@property", @"void"],
                    @"foreground": [UIColor redColor]}}
    ];
}
-(NSArray*)foundPattern:(NSString*)p {
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
-(void)styleOnRange:(NSRange)range fcolor:(UIColor*)fcolor {
    [_output addAttribute:(id)kCTForegroundColorAttributeName
                    value:(__bridge id)fcolor.CGColor range:range];
    
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
-(void)execOn:(NSMutableAttributedString *)attributedString FromFile:(File *)file {
    _output = attributedString;
    [self initPatterns];
    _content = [file getContents];
    [self iterPatternsAndApply];
}
@end
