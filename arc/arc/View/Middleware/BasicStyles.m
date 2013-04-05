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
//@synthesize settings = _settings;
//
//- (id)init {
//    self = [super init];
//    if (self) {
//        _settings = [NSArray arrayWithObjects:
//                     KEY_FONT_FAMILY,
//                     KEY_FONT_SIZE,
//                     nil];
//    }
//    return self;
//}

+ (void)arcAttributedString:(ArcAttributedString*)arcAttributedString OfFile:(id<File>)file delegate:(id)delegate;
{
    ApplicationState *state = [ApplicationState sharedApplicationState];
    
    CGColorRef color = [UIColor blackColor].CGColor;
    [arcAttributedString setColor:color];
    
    NSString *fontFamily = [state settingForKey:KEY_FONT_FAMILY];
    [arcAttributedString setFontFamily:fontFamily];
    
    int fontSize = [(NSNumber*)[state settingForKey:KEY_FONT_SIZE] intValue];
    [arcAttributedString setFontSize:fontSize];
}
@end
