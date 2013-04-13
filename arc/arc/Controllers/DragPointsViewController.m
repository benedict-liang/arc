//
//  DragPointsViewController.m
//  arc
//
//  Created by Benedict Liang on 14/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "DragPointsViewController.h"

@interface DragPointsViewController ()

@end

@implementation DragPointsViewController

- (id)initWithSelectedTextRect:(CGRect)selectedTextRect andOffset:(int)offset {
    self = [super init];
    
    if (self) {
        CGRect leftDragPointFrame = CGRectMake(selectedTextRect.origin.x + offset,
                                               selectedTextRect.origin.y,
                                               20,
                                               selectedTextRect.size.height);
        _leftDragPoint = [[DragPointImageView alloc] initWithFrame:leftDragPointFrame];
        
        CGRect rightDragPointFrame = CGRectMake(selectedTextRect.origin.x + selectedTextRect.size.width + offset,
                                               selectedTextRect.origin.y,
                                               20,
                                               selectedTextRect.size.height);
        _rightDragPoint = [[DragPointImageView alloc] initWithFrame:rightDragPointFrame];
        
        UIPanGestureRecognizer *leftPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(moveLeftDragPoint:)];
        UIPanGestureRecognizer *rightPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(moveRightDragPoint:)];
        [_leftDragPoint addGestureRecognizer:leftPanGesture];
        [_rightDragPoint addGestureRecognizer:rightPanGesture];
        
        _leftDragPoint.userInteractionEnabled = YES;
        _rightDragPoint.userInteractionEnabled = YES;
    }
    
    return self;
}

- (void)moveLeftDragPoint:(UIPanGestureRecognizer*)gesture {
    
}

- (void)moveRightDragPoint:(UIPanGestureRecognizer*)gesture {
    UITableView *tableView = (UITableView*)gesture.view.superview;
    CGPoint translation = [gesture translationInView:tableView];
    
    gesture.view.center = CGPointMake(gesture.view.center.x + translation.x, gesture.view.center.y);
    
    [gesture setTranslation:CGPointMake(0, 0) inView:tableView];
    [tableView reloadData];
    if ([gesture state] == UIGestureRecognizerStateChanged) {
        // Update selection rect
//        CGFloat originalX = self.frame.origin.x;
//        CGFloat newWidth = gesture.view.center.x - originalX;
//        
//        [self updateSize:CGSizeMake(newWidth, self.frame.size.height)];
    }
    
    else if ([gesture state] == UIGestureRecognizerStateEnded) {
        // Update substring
//        [self updateSelectionSubstring:cell];
//        
//        [self showCopyMenuForTextSelection];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
