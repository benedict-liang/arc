//
//  ArcAttributedString.m
//  arc
//
//  Created by Yong Michael on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "Constants.h"
#import <CoreText/CoreText.h>
#import "ArcAttributedString.h"

@interface ArcAttributedString ()
@property (nonatomic, strong) NSMutableAttributedString *_attributedString;
@property (nonatomic, strong) NSString *string;
@property (nonatomic, strong) NSString *fontFamily;
@property (nonatomic) CGColorRef color;
@property (nonatomic) NSRange stringRange;
@property (nonatomic)  int fontSize;
- (void)updateFontProperties;
@end

@implementation ArcAttributedString
@synthesize _attributedString = __attributedString;
@synthesize stringRange = _stringRange;
@synthesize fontFamily = _fontFamily;
@synthesize fontSize = _fontSize;
@synthesize color = _color;

- (id)initWithString:(NSString*)string
{
    self = [super init];
    if (self) {
        _fontFamily = (NSString*) DEFAULT_FONT_FAMILY;
        _color = (CGColorRef) DEFAULT_TEXT_COLOR;
        _fontSize = DEFAULT_FONT_SIZE;
        [self setString:string];
        __attributedString = [[NSMutableAttributedString alloc] initWithString:_string];
    }
    return self;
}


- (void)setString:(NSString *)string
{
    _string = string;
    _stringRange = NSMakeRange(0, _string.length);
}

- (void)setColor:(CGColorRef)color
{
    _color = color;
    [self setColor:_color OnRange:_stringRange];
}

- (void)setColor:(CGColorRef)color OnRange:(NSRange)range
{
    _color = color;
    [__attributedString addAttribute:(id)kCTForegroundColorAttributeName
                               value:(__bridge id)_color
                               range:range];
}

- (void)setFontSize:(int)fontSize
{
    _fontSize = fontSize;
    [self updateFontProperties];
    
}

- (void)setFontFamily:(NSString *)fontFamily
{
    _fontFamily = fontFamily;
    [self updateFontProperties];
}

- (void)updateFontProperties
{
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)_fontFamily, _fontSize, NULL);
    [__attributedString addAttribute:(id)kCTFontAttributeName
                               value:(__bridge id)font
                               range:_stringRange];
}

- (NSAttributedString*)attributedString
{
    return [[NSAttributedString alloc] initWithAttributedString:__attributedString];
}


@end
