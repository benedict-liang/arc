//
//  UICodeView.m
//  arc
//
//  Created by Yong Michael on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "UICodeView.h"

@implementation UICodeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)render:(FileObject*)file
{
    UIWebView *wv = [[UIWebView alloc] init];
    [wv loadHTMLString:@"<html contenteditable></html>" baseURL:nil];
    [self addSubview:wv];
}

@end
