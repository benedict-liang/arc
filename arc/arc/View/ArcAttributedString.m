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
@property (nonatomic, strong) NSAttributedString *cachedAttributedString;
@property (nonatomic, strong) NSMutableArray *attributes;
@property (nonatomic, strong) NSString *string;
@property (nonatomic, strong) NSString *fontFamily;
@property (nonatomic) NSRange stringRange;
@property (nonatomic)  int fontSize;
- (void)updateFontProperties;
@end

@implementation ArcAttributedString
@synthesize _attributedString = __attributedString;
@synthesize cachedAttributedString = _cachedAttributedString;
@synthesize attributes = _attributes;
@synthesize stringRange = _stringRange;
@synthesize fontFamily = _fontFamily;
@synthesize fontSize = _fontSize;

- (id)initWithString:(NSString*)string
{
    self = [super init];
    if (self) {
        _fontFamily = (NSString*) DEFAULT_FONT_FAMILY;
        _fontSize = DEFAULT_FONT_SIZE;
        [self setString:string];
        _attributes = [NSMutableArray array];
        __attributedString = [[NSMutableAttributedString alloc]
                              initWithString:_string];
        _cachedAttributedString = nil;
    }
    return self;
}
- (id)initWithArcAttributedString:(ArcAttributedString *)aas {

    self = [super init];
    if (self) {
        _fontFamily = [aas fontFamily];
        _fontSize = [aas fontSize];
        _attributes = [NSMutableArray array];
        __attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[aas attributedString]];
        _cachedAttributedString = nil;
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
    [__attributedString addAttribute:(id)kCTForegroundColorAttributeName
                               value:(__bridge id)color
                               range:_stringRange];
}

- (void)setColor:(CGColorRef)color OnRange:(NSRange)range
{
    [_attributes addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                           (__bridge id)color, @"value",
                           (id)kCTForegroundColorAttributeName, @"type",
                           NSStringFromRange(range), @"range",
                           nil]];
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

- (NSAttributedString*)plainAttributedString
{
    return [[NSAttributedString alloc] initWithAttributedString:__attributedString];
}

- (NSAttributedString*)attributedString
{
    if (_cachedAttributedString) {
        return _cachedAttributedString;
    }
    
    NSMutableAttributedString *tmp = [[NSMutableAttributedString alloc] initWithAttributedString:__attributedString];
    
    for (NSDictionary *prop in _attributes) {
        [tmp addAttribute:[prop objectForKey:@"type"]
                    value:[prop objectForKey:@"value"]
                    range:NSRangeFromString([prop objectForKey:@"range"])];
    }
    
    
    
    _cachedAttributedString = [[NSAttributedString alloc] initWithAttributedString:tmp];
    return _cachedAttributedString;
}

@end
