//
//  RegexUtils.m
//  arc
//
//  Created by omer iqbal on 22/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "RegexUtils.h"

@implementation RegexUtils
+ (NSRegularExpression *)regexForPattern:(NSString *)pattern {
    NSError *error = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:pattern
                                  options:NSRegularExpressionUseUnixLineSeparators|NSRegularExpressionAnchorsMatchLines
                                  error:&error];
    return regex;
}


+ (NSRange)findFirstPatternWithRegex:(NSRegularExpression *)regex
                               range:(NSRange)range
                             content:(NSString*)content
{
    if ((range.location + range.length <= [content length]) &&
        (range.length > 0) &&
        (range.length <= [content length]))
    {
        return [regex rangeOfFirstMatchInString:content
                                        options:0
                                          range:range];
    } else {
        return NSMakeRange(NSNotFound, 0);
    }
}
+ (NSRange)findFirstPattern:(NSString*)pattern
                      range:(NSRange)range
                    content:(NSString*)content
{
    
    NSRegularExpression *regex = [RegexUtils regexForPattern:pattern];
    
    if ((range.location + range.length <= [content length]) &&
        (range.length > 0) &&
        (range.length <= [content length]))
    {
        //NSLog(@"findFirstPattern:   %d %d",r.location,r.length);
        return [regex rangeOfFirstMatchInString:content
                                        options:0
                                          range:range];
    } else {
        NSLog(@"index out of bounds in regex. findFirstPatten:%@",[Utils valueFromRange:range]);
        return NSMakeRange(NSNotFound, 0);
    }
    
}

+ (NSArray*)foundPattern:(NSString*)pattern
                 capture:(int)capture
                   range:(NSRange)range
                 content:(NSString*)content
{
    NSMutableArray* results = [[NSMutableArray alloc] init];
    NSRegularExpression *regex = [RegexUtils regexForPattern:pattern];
    
    if (range.location + range.length <= [content length]) {
        
        NSArray* matches = [regex matchesInString:content
                                          options:0
                                            range:range];
        
        for (NSTextCheckingResult *match in matches) {
            if (capture < [match numberOfRanges]) {
                NSRange range = [match rangeAtIndex:capture];
                
                if (range.location != NSNotFound) {
                    NSValue* v = [NSValue value:&range
                                   withObjCType:@encode(NSRange)];
                    [results addObject:v];
                }
            }
            
        }
        
    } else {
        NSLog(@"index error in capture:%d %d", range.location, range.length);
    }
    
    return results;
}


@end
