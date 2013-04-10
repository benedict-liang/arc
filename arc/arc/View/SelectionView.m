//
//  SelectionView.m
//  arc
//
//  Created by Benedict Liang on 9/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SelectionView.h"

@implementation SelectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        NSLog(@"init");
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    //CGColorRef darkColor = [[UIColor colorWithRed:21.0/255.0 green:92.0/255.0 blue:136.0/255.0 alpha:1.0] CGColor];
    CGColorRef darkColor = [[UIColor blueColor] CGColor];
    darkColor = CGColorCreateCopyWithAlpha(darkColor, 0.5);
    CGContextSetFillColorWithColor(context, darkColor);
    CGContextFillRect(context, rect);
}

- (BOOL)canBecomeFirstResponder {
    // NOTE: This menu item will not show if this is not YES!
    return YES;
}


@end
