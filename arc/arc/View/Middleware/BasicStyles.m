//
//  BasicStyles.m
//  arc
//
//  Created by Yong Michael on 26/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <CoreText/CoreText.h>
#import "BasicStyles.h"

@implementation BasicStyles
- (void)execOn:(NSMutableAttributedString*) attributedString FromFile:(File*)file
{
    CGColorRef color = [UIColor blackColor].CGColor;
    CTFontRef font = CTFontCreateWithName(CFSTR("Source Code Pro"), 20.0, NULL);
    
    [attributedString addAttribute:(id)kCTForegroundColorAttributeName
                              value:(__bridge id)color
                              range:NSMakeRange(0, attributedString.string.length)];
    
    [attributedString addAttribute:(id)kCTFontAttributeName
                              value:(__bridge id)font
                              range:NSMakeRange(0, attributedString.string.length)];
}
@end
