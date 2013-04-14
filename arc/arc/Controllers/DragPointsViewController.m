//
//  DragPointsViewController.m
//  arc
//
//  Created by Benedict Liang on 14/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "DragPointsViewController.h"

@interface DragPointsViewController ()

@property (nonatomic) CGRect currentBottomRowCellRect;
@property (nonatomic) CGRect currentTopRowCellRect;

@property (nonatomic) CGRect nextBottomRowCellRect;
@property (nonatomic) CGRect nextTopRowCellRect;
@property (nonatomic, strong) NSIndexPath *nextBottomRowIndexPath;
@property (nonatomic, strong) NSIndexPath *nextTopRowIndexPath;

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

// TODO: Move drag points and update background color range
// TODO: Set boundary conditions

- (void)moveLeftDragPoint:(UIPanGestureRecognizer*)gesture {
    
}

- (void)moveRightDragPoint:(UIPanGestureRecognizer*)gesture {
    
    if ([gesture state] == UIGestureRecognizerStateBegan) {
        [self calculateRectValues];
    }
    
    if ([gesture state] == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:_tableView];
        gesture.view.center = CGPointMake(gesture.view.center.x, gesture.view.center.y + translation.y);
        [gesture setTranslation:CGPointMake(0, 0) inView:_tableView];
        
        int midDistance = _nextBottomRowCellRect.origin.y - _currentBottomRowCellRect.origin.y;
        
        // y-direction changed
        // => get cell for position
        if (gesture.view.center.y > (_currentBottomRowCellRect.origin.y + midDistance)) {
            gesture.view.center = CGPointMake(gesture.view.center.x, _nextBottomRowCellRect.origin.y + _nextBottomRowCellRect.size.height/2);
            NSLog(@"Moved a line");
//            [self updateRectValues];
        }
        
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

- (void)moveRightDragPointHorizontal:(UIPanGestureRecognizer*)gesture {
    UITableView *tableView = (UITableView*)gesture.view.superview;
    CGPoint translation = [gesture translationInView:tableView];
    
    gesture.view.center = CGPointMake(gesture.view.center.x + translation.x, gesture.view.center.y);
    
    [gesture setTranslation:CGPointMake(0, 0) inView:tableView];
//    [tableView reloadData];
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

- (void)calculateRectValues {
    _currentTopRowCellRect = [_tableView rectForRowAtIndexPath:_topIndexPath];
    _currentBottomRowCellRect = [_tableView rectForRowAtIndexPath:_bottomIndexPath];
    
    int topRow = _topIndexPath.row;
    int bottomRow = _bottomIndexPath.row;

    if (topRow - 1 >= 0) {
        _nextTopRowIndexPath = [NSIndexPath indexPathForRow:(topRow - 1) inSection:0];
        _nextTopRowCellRect = [_tableView rectForRowAtIndexPath:_nextTopRowIndexPath];
    }
    else {
        _nextTopRowIndexPath = nil;
        _nextTopRowCellRect = CGRectNull;
    }
    
    if (bottomRow + 1 < [_tableView numberOfRowsInSection:0]) {
        _nextBottomRowIndexPath = [NSIndexPath indexPathForRow:(bottomRow + 1) inSection:0];
        _nextBottomRowCellRect = [_tableView rectForRowAtIndexPath:_nextBottomRowIndexPath];
    }
    else {
        _nextBottomRowIndexPath = nil;
        _nextBottomRowCellRect = CGRectNull;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
