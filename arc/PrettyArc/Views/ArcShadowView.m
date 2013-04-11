//
//  ArcShadowView.m
//  arc
//
//  Created by Yong Michael on 11/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ArcShadowView.h"

@interface ArcShadowView ()
@property (nonatomic) CGRect coloredBoxRect;
@end

@implementation ArcShadowView

- (id)init
{
    if ((self = [super init])) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
	}
	return self;
}

- (void)layoutSubviews
{
	CGFloat coloredBoxMargin = 40;
    CGFloat coloredBoxHeight = self.frame.size.height;
    _coloredBoxRect = CGRectMake(coloredBoxMargin,
                                 0,
                                 40,
                                 coloredBoxHeight);
}

- (void)drawRect:(CGRect)rect
{
    
	UIColor *lightColor =  [UIColor colorWithRed:105.0f/255.0f
                                             green:179.0f/255.0f
                                              blue:216.0f/255.0f
                                             alpha:0.8];
    
    UIColor *shadowColor = [UIColor colorWithRed:0.2
                                             green:0.2
                                              blue:0.2
                                             alpha:0.4];
    
	CGContextRef context = UIGraphicsGetCurrentContext();
	
    // Draw shadow
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, CGSizeMake(-5, 0), 10, shadowColor.CGColor);
	CGContextSetFillColorWithColor(context, lightColor.CGColor);
    CGContextFillRect(context, _coloredBoxRect);
	CGContextRestoreGState(context);
}

@end
