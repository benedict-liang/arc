//
//  DragPointsViewController.m
//  arc
//
//  Created by Benedict Liang on 14/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "DragPointsViewController.h"
#import "CodeLineCell.h"

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
        CGFloat cellHeight = _currentBottomRowCellRect.size.height;
        CGFloat quarterDistance = cellHeight / 4;
        BOOL selectionDidChange = NO;
        
        // y-direction changed
        // => get cell for position
        if (translation.y > quarterDistance) {
            [self updateBottomRectValuesWithBottomIndexPath:_nextBottomRowIndexPath];
            gesture.view.center = CGPointMake(gesture.view.center.x, _currentBottomRowCellRect.origin.y + cellHeight/2);
            [gesture setTranslation:CGPointMake(0, 0) inView:_tableView];
            selectionDidChange = YES;
        }
        
        if (translation.y < -quarterDistance && (_topIndexPath.row != _bottomIndexPath.row)) {
            [self updateBottomRectValuesWithBottomIndexPath:
             [NSIndexPath indexPathForRow:_bottomIndexPath.row-1
                                inSection:0]];
            gesture.view.center = CGPointMake(gesture.view.center.x, _currentBottomRowCellRect.origin.y + cellHeight/2);
            [gesture setTranslation:CGPointMake(0, 0) inView:_tableView];
            selectionDidChange = YES;
        }
        
        if (selectionDidChange) {
            CGPoint endPointInRow = CGPointMake(gesture.view.center.x, 0);
            CodeLineCell *cell = (CodeLineCell*)[_tableView cellForRowAtIndexPath:_bottomIndexPath];
            CTLineRef lineRef = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)
                                                                 (cell.line));
            CFIndex index = CTLineGetStringIndexForPosition(lineRef, endPointInRow);
            int endLocation = cell.stringRange.location + index - 1;
            _selectedTextRange = NSMakeRange(_selectedTextRange.location, endLocation - _selectedTextRange.location);
            [_codeViewController setBackgroundColorForString:[UIColor blueColor]
                                                   WithRange:_selectedTextRange
                                                  forSetting:@"copyAndPaste"];
            [_tableView reloadData];
        }
    }
}

- (void)updateBottomRectValuesWithBottomIndexPath:(NSIndexPath*)bottomIndexPath {
    _bottomIndexPath = [NSIndexPath indexPathForRow:bottomIndexPath.row inSection:0];
    _currentBottomRowCellRect = [_tableView rectForRowAtIndexPath:bottomIndexPath];
    
    int bottomRow = _bottomIndexPath.row;
    
    if (bottomRow + 1 < [_tableView numberOfRowsInSection:0]) {
        _nextBottomRowIndexPath = [NSIndexPath indexPathForRow:(bottomRow + 1) inSection:0];
        _nextBottomRowCellRect = [_tableView rectForRowAtIndexPath:_nextBottomRowIndexPath];
    }
    else {
        _nextBottomRowIndexPath = nil;
        _nextBottomRowCellRect = CGRectNull;
    }
}

- (void)calculateRectValues {
    [self calculateRectValuesForRows];
}

- (void)calculateRectValuesForRows {
    _topRowCellRect = [_tableView rectForRowAtIndexPath:_topIndexPath];
    _bottomRowCellRect = [_tableView rectForRowAtIndexPath:_bottomIndexPath];
    
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
