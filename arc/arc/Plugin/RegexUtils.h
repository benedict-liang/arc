//
//  RegexUtils.h
//  arc
//
//  Created by omer iqbal on 22/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegexUtils : NSObject
+ (NSRange)findFirstPatternWithRegex:(NSRegularExpression *)regex
                               range:(NSRange)range
                             content:(NSString*)content;

+ (NSRegularExpression *)regexForPattern:(NSString *)pattern;

+ (NSArray*)foundPattern:(NSString*)pattern
                 capture:(int)capture
                   range:(NSRange)range
                 content:(NSString*)content;

+ (NSRange)findFirstPattern:(NSString*)pattern
                      range:(NSRange)range
                    content:(NSString*)content;
@end
