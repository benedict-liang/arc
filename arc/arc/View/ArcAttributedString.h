//
//  ArcAttributedString.h
//  arc
//
//  Created by Yong Michael on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArcAttributedString : NSObject
@property (nonatomic, readonly) NSString *string;
@property (nonatomic, readonly) NSRange stringRange;
@property (nonatomic, readonly) NSAttributedString *attributedString;
@property (nonatomic, readonly) NSAttributedString *plainAttributedString;
@property (nonatomic, readonly) NSDictionary *attributesDictionary;
@property (nonatomic, readonly) NSDictionary *appliedAttributesDictionary;

// Constructors
- (id)initWithString:(NSString*)string;
- (id)initWithArcAttributedString:(ArcAttributedString*)arcAttributedString;

//
// Attributed String Mutators
//

// Font{Size, Family}
- (void)setFontSize:(int)fontSize;
- (void)setFontFamily:(NSString*)fontFamily;

// Color
- (void)setColor:(CGColorRef)color
         OnRange:(NSRange)range
      ForSetting:(NSString*)settingKey;

// Remove Attributes based on settings Key
- (void)removeAttributesForSettingKey:(NSString*)settingKey;
@end
