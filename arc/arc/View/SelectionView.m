//
//  SelectionView.m
//  arc
//
//  Created by Benedict Liang on 9/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SelectionView.h"
#import "CodeLineCell.h"

@implementation SelectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        [self createDragPoints];
        NSLog(@"init");
    }
    return self;
}

- (void)createDragPoints {
    CGFloat excessHeight = self.frame.size.height * 0.2;
    CGSize dragPointSize = CGSizeMake(5, self.frame.size.height + excessHeight);
    UIView *rightDragPoint = [[UIView alloc]
                              initWithFrame:CGRectMake(self.frame.origin.x + self.frame.size.width - 2,
                                                       0,
                                                       dragPointSize.width,
                                                       dragPointSize.height)];
    rightDragPoint.backgroundColor = [UIColor redColor];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(moveRightDragPoint:)];
    [rightDragPoint addGestureRecognizer:panGesture];
    _rightDragPoint = rightDragPoint;
    [_rightDragPoint setClipsToBounds:NO];
}

- (void)moveRightDragPoint:(UIPanGestureRecognizer*)panGesture {
    CodeLineCell *cell = (CodeLineCell*)panGesture.view.superview;
    CGPoint translation = [panGesture translationInView:cell];
    
    panGesture.view.center = CGPointMake(panGesture.view.center.x + translation.x, panGesture.view.center.y);
    
    [panGesture setTranslation:CGPointMake(0, 0) inView:cell];
    
    if ([panGesture state] == UIGestureRecognizerStateEnded) {
        // Update selection rect
        CGFloat originalX = self.frame.origin.x;
        CGFloat newWidth = panGesture.view.center.x - originalX;
        
        [self updateSize:CGSizeMake(newWidth, self.frame.size.height)];
        
        // Update substring
        [self updateSelectionSubstring:cell];
        
        [[NSNotificationCenter defaultCenter] postNotification:
         [NSNotification notificationWithName:@"showCopyMenu" object:nil]];
    }
}

- (void)updateSelectionSubstring:(CodeLineCell*)cell {
    CGFloat startX = self.frame.origin.x;
    CGFloat endX = startX + self.frame.size.width;
    CTLineRef line = cell.line;
    NSString *cellString = cell.string;
    CFIndex startIndex = CTLineGetStringIndexForPosition(line, CGPointMake(startX, 0));
    CFIndex endIndex = CTLineGetStringIndexForPosition(line, CGPointMake(endX, 0));
    self.selectedString = [cellString substringWithRange:NSMakeRange(startIndex, endIndex - startIndex)];
}

- (void)updateSize:(CGSize)updatedSize {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, updatedSize.width, updatedSize.height);
    [self setNeedsDisplay];
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
