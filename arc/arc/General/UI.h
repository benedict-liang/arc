//
//  UI.h
//  arc
//
//  Created by Yong Michael on 21/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UI : NSObject
+ (void)exec;

// properties
+ (UIColor *)navigationBarColor;
+ (UIColor *)navigationBarButtonColor;
+ (UIColor *)toolBarColor;
+ (UIColor *)fontColor;
+ (NSString *)fontName;
+ (UIFont *)toolBarTitleFont;

// Images
+ (NSString *)folderImage;
+ (NSString *)fileImage;
+ (NSString *)fileImageHighlighted;
@end
