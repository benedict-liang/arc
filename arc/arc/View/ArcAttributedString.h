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
@property (nonatomic, readonly) NSAttributedString *attributedString;
@property (nonatomic, readonly) NSAttributedString *plainAttributedString;
- (id)initWithString:(NSString*)string;

// to change
- (id)initWithArcAttributedString:(ArcAttributedString*)arcAttributedString;

// Properties
- (void)setFontSize:(int)fontSize;
- (void)setFontFamily:(NSString*)fontFamily;
- (void)setColor:(CGColorRef)color
         OnRange:(NSRange)range
      ForSetting:(NSString*)settingKey;
@end
