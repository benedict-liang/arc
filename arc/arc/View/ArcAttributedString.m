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
#import "ApplicationState.h"

@interface ArcAttributedString ()
@property (nonatomic, strong) NSMutableAttributedString *_attributedString;
@property (nonatomic, strong) NSMutableDictionary *attributesDictionary;
@property (nonatomic, strong) NSString *string;
@property (nonatomic) NSRange stringRange;

// Font
@property (nonatomic, strong) NSString *fontFamily;
@property (nonatomic) int fontSize;
- (void)updateFontProperties;
@end

@implementation ArcAttributedString

- (id)initWithString:(NSString*)string
{
    self = [super init];
    if (self) {
        _string = string;
        _stringRange = NSMakeRange(0, _string.length);
        
        __attributedString = [[NSMutableAttributedString alloc]
                              initWithString:_string];
        
        // Used to store (buffer attributes)
        _attributesDictionary = [NSDictionary dictionary];
    }
    return self;
}

- (id)initWithArcAttributedString:(ArcAttributedString *)arcAttributedString
{
    self = [super init];
    if (self) {
        _fontFamily = [arcAttributedString fontFamily];
        _fontSize = [arcAttributedString fontSize];
        __attributedString = [[NSMutableAttributedString alloc]
                              initWithAttributedString:[arcAttributedString attributedString]];
    }
    return self;
}

- (void)removeAttributesForSettingKey:(NSString*)settingKey
{
    for (NSDictionary *attribute in [_attributesDictionary objectForKey:settingKey]) {
        [__attributedString removeAttribute:[attribute objectForKey:@"type"]
                                      range:NSRangeFromString([attribute objectForKey:@"range"])];
    }
}

- (NSAttributedString*)attributedString
{
    for (NSArray *propertyAttributes in _attributesDictionary) {
        for (NSDictionary *attribute in propertyAttributes) {
            [__attributedString addAttribute:[attribute objectForKey:@"type"]
                                       value:[attribute objectForKey:@"value"]
                                       range:NSRangeFromString([attribute objectForKey:@"range"])];
        }
    }
    
    return __attributedString;
}

- (NSAttributedString*)plainAttributedString
{
    return [[NSAttributedString alloc]
            initWithAttributedString:__attributedString];
}

# pragma mark - Color Methods

- (void)setColor:(CGColorRef)color
         OnRange:(NSRange)range
      ForSetting:(NSString*)settingKey
{
    NSMutableArray *settingAttributes = [self settingsAttributeForSettingsKey:settingKey];
    [settingAttributes addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                  (__bridge id)color, @"value",
                                  (id)kCTForegroundColorAttributeName, @"type",
                                  NSStringFromRange(range), @"range",
                                  nil]];
}

# pragma mark - Namespaced Attributes

- (NSMutableArray*)settingsAttributeForSettingsKey:(NSString*)settingKey
{
    NSMutableArray *settingAttributes = [_attributesDictionary objectForKey:settingKey];

    if (settingAttributes == nil) {
        settingAttributes = [NSMutableArray array];
        [_attributesDictionary setValue:settingAttributes forKey:settingKey];
    }

    return settingAttributes;
}

# pragma mark - FontSize/Family Methods

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
    // Remove old font property
    [__attributedString removeAttribute:(id)kCTFontAttributeName
                                  range:_stringRange];
    
    // update font to new property
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)_fontFamily, _fontSize, NULL);
    [__attributedString addAttribute:(id)kCTFontAttributeName
                               value:(__bridge id)font
                               range:_stringRange];
}

@end
