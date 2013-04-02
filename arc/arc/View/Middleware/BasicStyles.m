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
    ApplicationState *state = [ApplicationState sharedApplicationState];
    
    CGColorRef color = [UIColor blackColor].CGColor;
    [arcAttributedString setColor:color];
    
    NSString *fontFamily = [state fontFamily];
    [arcAttributedString setFontFamily:fontFamily];
    
    int fontSize = [state fontSize];
    [arcAttributedString setFontSize:fontSize];
}
@end
