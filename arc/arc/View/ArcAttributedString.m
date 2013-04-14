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
@property (nonatomic, strong) NSMutableAttributedString *_plainAttributedString;
@property (nonatomic, strong) NSMutableDictionary *_attributesDictionary;
@property (nonatomic, strong) NSMutableDictionary *_appliedAttributesDictionary;

// Font
@property (nonatomic, strong) NSString *fontFamily;
@property (nonatomic) int fontSize;
- (void)updateFontProperties;
@end

@implementation ArcAttributedString
@synthesize string = _string;
@synthesize stringRange = _stringRange;

- (id)initWithString:(NSString*)string
{
    self = [super init];
    if (self) {
        _string = string;
        _stringRange = NSMakeRange(0, _string.length);
        __attributedString = [[NSMutableAttributedString alloc]
                              initWithString:_string];
        
        __plainAttributedString = [[NSMutableAttributedString alloc]
                                  initWithString:_string];
        
        // Used to store(buffer) attributes
        __attributesDictionary = [NSMutableDictionary dictionary];
        __appliedAttributesDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)initWithArcAttributedString:(ArcAttributedString *)arcAttributedString
{
    self = [super init];
    if (self) {
        _string = [arcAttributedString string];
        _stringRange = NSMakeRange(0, _string.length);
        _fontFamily = [arcAttributedString fontFamily];
        _fontSize = [arcAttributedString fontSize];
        __attributedString = [[NSMutableAttributedString alloc]
                              initWithAttributedString:[arcAttributedString attributedString]];
        
        __plainAttributedString = [[NSMutableAttributedString alloc]
                                   initWithAttributedString:[arcAttributedString plainAttributedString]];
        
        // Used to store (buffer attributes)
        __attributesDictionary = [NSMutableDictionary dictionaryWithDictionary:
                                 [arcAttributedString attributesDictionary]];
        __appliedAttributesDictionary = [NSMutableDictionary dictionaryWithDictionary:
                                        [arcAttributedString appliedAttributesDictionary]];
    }
    return self;
}

- (void)removeAttributesForSettingKey:(NSString*)settingKey
{
    for (NSDictionary *attribute in [__appliedAttributesDictionary objectForKey:settingKey]) {
        [__attributedString removeAttribute:[attribute objectForKey:@"type"]
                                      range:NSRangeFromString([attribute objectForKey:@"range"])];
    }
    
    // remove object from dictionary
    [__appliedAttributesDictionary removeObjectForKey:settingKey];
}

- (NSAttributedString*)attributedString
{    
    for (NSString* property in __attributesDictionary) {
        for (NSDictionary* attribute in [__attributesDictionary objectForKey:property]) {
            [__attributedString addAttribute:[attribute objectForKey:@"type"]
                                       value:[attribute objectForKey:@"value"]
                                       range:NSRangeFromString([attribute objectForKey:@"range"])];
        }
        
        // Move attributes to appliedAttributes dictionary
        [[self settingsAppliedAttributeForSettingsKey:property]
            addObjectsFromArray:[self settingsAttributeForSettingsKey:property]];
        [__attributesDictionary removeObjectForKey:property];
    }

    return __attributedString;
}

- (NSAttributedString*)plainAttributedString
{
    return [[NSAttributedString alloc]
            initWithAttributedString:__plainAttributedString];
}

# pragma mark - getters

- (NSDictionary*)attributesDictionary
{
    return [NSDictionary dictionaryWithDictionary:__attributesDictionary];
}


- (NSDictionary*)appliedAttributesDictionary
{
    return [NSDictionary dictionaryWithDictionary:__appliedAttributesDictionary];
}

# pragma mark - AttributedString Mutator Methods

- (void)setForegroundColor:(UIColor *)color
                   OnRange:(NSRange)range
                ForSetting:(NSString*)settingKey
{
    NSMutableArray *settingAttributes =
    [self settingsAttributeForSettingsKey:settingKey];
    
    [settingAttributes addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                  color, @"value",
                                  NSForegroundColorAttributeName, @"type",
                                  NSStringFromRange(range), @"range",
                                  nil]];
}

- (void)setBackgroundColor:(UIColor *)color
                   OnRange:(NSRange)range
                ForSetting:(NSString *)settingKey
{
    NSMutableArray *settingAttributes =
    [self settingsAttributeForSettingsKey:settingKey];
    
    [settingAttributes addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                  color, @"value",
                                  NSBackgroundColorAttributeName, @"type",
                                  NSStringFromRange(range), @"range",
                                  nil]];
}

# pragma mark - Namespaced Attributes

- (NSMutableArray*)settingsAttributeForSettingsKey:(NSString*)settingKey
{
    NSMutableArray *settingAttributes =
    [__attributesDictionary objectForKey:settingKey];

    if (settingAttributes == nil) {
        settingAttributes = [NSMutableArray array];
        [__attributesDictionary setValue:settingAttributes
                                  forKey:settingKey];
    }

    return settingAttributes;
}

- (NSMutableArray*)settingsAppliedAttributeForSettingsKey:(NSString*)settingKey
{
    NSMutableArray *settingAppliedAttributes =
    [__appliedAttributesDictionary objectForKey:settingKey];
    
    if (settingAppliedAttributes == nil) {
        settingAppliedAttributes = [NSMutableArray array];
        [__appliedAttributesDictionary setValue:settingAppliedAttributes
                                         forKey:settingKey];
    }
    
    return settingAppliedAttributes;
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
    [__attributedString removeAttribute:NSFontAttributeName
                                  range:_stringRange];
    
    [__plainAttributedString removeAttribute:NSFontAttributeName
                                  range:_stringRange];
    
    // update font to new property
    UIFont *font = [UIFont fontWithName:_fontFamily size:_fontSize];
    
    [__attributedString addAttribute:NSFontAttributeName
                               value:font
                               range:_stringRange];

    [__plainAttributedString addAttribute:NSFontAttributeName
                               value:font
                               range:_stringRange];
    
}
- (ArcAttributedString*)arcStringWithRemovedRange:(NSRange)range {
    int rangeEnds = range.location + range.length;
    
    // create str not including range.
    NSMutableString* str = [NSMutableString stringWithString:[_string substringToIndex:range.location]];
    [str appendString:[_string substringFromIndex:rangeEnds]];
    
    // create arcString from str
    ArcAttributedString* removedArcString = [[ArcAttributedString alloc] initWithString:str];
    NSMutableDictionary* removedAttributesDictionary = [NSMutableDictionary dictionary];
    
    // iterate through attributes and transform attributes for the new ranges
    for (NSString *property in __attributesDictionary) {
        
        for (NSDictionary* attribute in [__attributesDictionary objectForKey:property]) {
            NSRange attribRange = NSRangeFromString([attribute objectForKey:@"range"]);
            
            //check if attribRange intersects range
            if ([Utils isSubsetOf:range arg:attribRange]) {
                //do nothing.
            }
            else if ([Utils isIntersectingWith:range And:attribRange]) {
                
                NSArray* cleanedRangeArray = [Utils rangeDifferenceBetween:attribRange And:range];
                
            
            } else {
                
            }
            
            [__attributedString addAttribute:[attribute objectForKey:@"type"]
                                       value:[attribute objectForKey:@"value"]
                                       range:NSRangeFromString([attribute objectForKey:@"range"])];
        }
 
    }
    
    return removedArcString;
}
@end
