//
//  CodeLine.m
//  arc
//
//  Created by Yong Michael on 6/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "CodeLine.h"

@interface CodeLine ()
@property (nonatomic) CTLineRef line;
@end

@implementation CodeLine


- (id)initWithLine:(CTLineRef)line
{
    self = [super init];
    if (self) {
        self.layer.geometryFlipped = YES;
        self.backgroundColor = [UIColor whiteColor];
        _line = line;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextPosition(context, 20, rect.size.height/4.0f);
    CTLineDraw(_line, context);
}

@end
