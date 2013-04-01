//
//  BasicStyles.m
//  arc
//
//  Created by Yong Michael on 26/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <CoreText/CoreText.h>
#import "ArcAttributedString.h"
#import "BasicStyles.h"

@implementation BasicStyles
+ (void)arcAttributedString:(ArcAttributedString*)arcAttributedString OfFile:(id<File>)file delegate:(id)del;
{
    CGColorRef color = [UIColor blackColor].CGColor;
    [arcAttributedString setColor:color];
    
    NSString *fontFamily = @"SourceCodePro-Regular";
    [arcAttributedString setFontFamily:fontFamily];
    
    int fontSize = 24;
    [arcAttributedString setFontSize:fontSize];
}
@end
