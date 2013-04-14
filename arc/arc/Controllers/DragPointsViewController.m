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

@property (nonatomic) int lineNumberWidthOffSet;

@property (nonatomic) CGRect bottomRowCellRect;
@property (nonatomic) CGRect topRowCellRect;

@property (nonatomic) CGRect nextBottomRowCellRect;
@property (nonatomic) CGRect nextTopRowCellRect;
@property (nonatomic, strong) NSIndexPath *nextBottomRowIndexPath;
@property (nonatomic, strong) NSIndexPath *nextTopRowIndexPath;

@property (nonatomic) CGPoint firstCharacterCoordinates;
@property (nonatomic) CGPoint lastCharacterCoordinates;

@property (nonatomic) CGPoint previousLastCharacterCoordinates;
@property (nonatomic) CGPoint nextLastCharacterCoordinates;

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
        
        UIPanGestureRecognizer *leftPanGestureHorizontal = [[UIPanGestureRecognizer alloc]
                                                            initWithTarget:self
                                                            action:@selector(moveLeftDragPointHorizontal:)];
        UIPanGestureRecognizer *leftPanGestureVertical = [[UIPanGestureRecognizer alloc]
                                                          initWithTarget:self
                                                          action:@selector(moveLeftDragPointVertical:)];
        UIPanGestureRecognizer *rightPanGestureHorizontal = [[UIPanGestureRecognizer alloc]
                                                             initWithTarget:self
                                                             action:@selector(moveRightDragPointHorizontal:)];
        UIPanGestureRecognizer *rightPanGestureVertical = [[UIPanGestureRecognizer alloc]
                                                           initWithTarget:self
                                                           action:@selector(moveRightDragPointVertical:)];

        [leftPanGestureHorizontal setDelegate:self];
        [leftPanGestureVertical setDelegate:self];
        [_leftDragPoint addGestureRecognizer:leftPanGestureHorizontal];
        [_leftDragPoint addGestureRecognizer:leftPanGestureVertical];
        
        [rightPanGestureHorizontal setDelegate:self];
        [rightPanGestureVertical setDelegate:self];
        [_rightDragPoint addGestureRecognizer:rightPanGestureHorizontal];
        [_rightDragPoint addGestureRecognizer:rightPanGestureVertical];
        
        _leftDragPoint.userInteractionEnabled = YES;
        _rightDragPoint.userInteractionEnabled = YES;
        
        _lineNumberWidthOffSet = offset;
    }
    
    return self;
}

#pragma mark - Drag Points

// TODO: Move drag points and update background color range
// TODO: Set boundary conditions - Prevent left and right drag points from colliding
// -> Always leave at least 1 character in between them

- (void)moveLeftDragPointHorizontal:(UIPanGestureRecognizer*)gesture {

}

- (void)moveLeftDragPointVertical:(UIPanGestureRecognizer*)gesture {
    if ([gesture state] == UIGestureRecognizerStateBegan) {
        [self calculateRectValues];
        _tableView.scrollEnabled = NO;
    }
    
    if ([gesture state] == UIGestureRecognizerStateChanged) {
        
        // Set thresholds
        CGFloat cellHeight = _topRowCellRect.size.height;
        CGFloat threshold = cellHeight / 4;
        
        // Checks if cells are within visible range
        NSArray *visibleCells = _tableView.visibleCells;
        NSIndexPath *previousCellIndexPath = [NSIndexPath indexPathForRow:_topIndexPath.row+1
                                                                inSection:0];
        UITableViewCell *nextTopCell = [_tableView cellForRowAtIndexPath:_nextTopRowIndexPath];
        UITableViewCell *previousTopCell = [_tableView cellForRowAtIndexPath:previousCellIndexPath];
        
        
        CGPoint translation = [gesture translationInView:_tableView];
        BOOL selectionDidChange = NO;
        
        // Selecting upwards
        if (translation.y < -threshold &&
            [visibleCells containsObject:nextTopCell]) {
            
            [self updateTopRectValuesWithTopIndexPath:_nextTopRowIndexPath];
            selectionDidChange = YES;
        }
        
        
        // Selecting downwards
        if (translation.y > threshold &&
            (_topIndexPath.row != _bottomIndexPath.row) &&
            [visibleCells containsObject:previousTopCell]) {
            
            [self updateTopRectValuesWithTopIndexPath:previousCellIndexPath];
            selectionDidChange = YES;
        }
        
        
        
        if (selectionDidChange) {
            gesture.view.center = CGPointMake(gesture.view.center.x,
                                              _topRowCellRect.origin.y + cellHeight/2);
            [gesture setTranslation:CGPointMake(0, 0)
                             inView:_tableView];
            CGPoint startPointInRow = CGPointMake(gesture.view.center.x, 0);
            [self updateBackgroundColorForLeftDragPoint:startPointInRow];
        }
    }
    
    if ([gesture state] == UIGestureRecognizerStateEnded) {
        _tableView.scrollEnabled = YES;
    }
}

- (void)moveRightDragPointHorizontal:(UIPanGestureRecognizer*)gesture {
    
    if ([gesture state] == UIGestureRecognizerStateBegan) {
        [self calculateRectValues];
    }
    
    if ([gesture state] == UIGestureRecognizerStateChanged) {
        
        // Set thresholds
        CGFloat forwardDifference = _nextLastCharacterCoordinates.x - _lastCharacterCoordinates.x;
        CGFloat backwardDifference = _lastCharacterCoordinates.x - _previousLastCharacterCoordinates.x;
        CGFloat forwardThreshold = forwardDifference / 2;
        CGFloat backwardThreshold = - backwardDifference / 2;
        
        CGPoint translation = [gesture translationInView:_tableView];
        BOOL selectionDidChange = NO;
        
        // Select forward
        if (translation.x > forwardThreshold) {
            [self updateLastCharacterValues:_nextLastCharacterCoordinates];
            selectionDidChange = YES;
        }
        
        // Select backward
        if (translation.x < backwardThreshold) {
            [self updateLastCharacterValues:_previousLastCharacterCoordinates];
            selectionDidChange = YES;
        }
        
        if (selectionDidChange) {
            gesture.view.center = CGPointMake(_lastCharacterCoordinates.x, gesture.view.center.y);
            [gesture setTranslation:CGPointMake(0, 0) inView:_tableView];
            CGPoint endPointInRow = CGPointMake(gesture.view.center.x, 0);
            [self updateBackgroundColorForRightDragPoint:endPointInRow];
        }
    }
}

- (void)moveRightDragPointVertical:(UIPanGestureRecognizer*)gesture {
    
    if ([gesture state] == UIGestureRecognizerStateBegan) {
        [self calculateRectValues];
        _tableView.scrollEnabled = NO;
    }
    
    if ([gesture state] == UIGestureRecognizerStateChanged) {
        
        // Set thresholds
        CGFloat cellHeight = _bottomRowCellRect.size.height;
        CGFloat threshold = cellHeight / 4;
        
        // Checks if cells are within visible range
        NSArray *visibleCells = _tableView.visibleCells;
        NSIndexPath *previousCellIndexPath = [NSIndexPath indexPathForRow:_bottomIndexPath.row-1
                                                                inSection:0];
        UITableViewCell *nextBottomCell = [_tableView cellForRowAtIndexPath:_nextBottomRowIndexPath];
        UITableViewCell *previousBottomCell = [_tableView cellForRowAtIndexPath:previousCellIndexPath];
        
        
        CGPoint translation = [gesture translationInView:_tableView];
        BOOL selectionDidChange = NO;
        
        
        // Selecting downwards
        if (translation.y > threshold &&
            [visibleCells containsObject:nextBottomCell]) {
            
            [self updateBottomRectValuesWithBottomIndexPath:_nextBottomRowIndexPath];
            selectionDidChange = YES;
        }
        
        // Selecting upwards
        if (translation.y < -threshold &&
            (_topIndexPath.row != _bottomIndexPath.row) &&
            [visibleCells containsObject:previousBottomCell]) {
            
            [self updateBottomRectValuesWithBottomIndexPath:previousCellIndexPath];
            selectionDidChange = YES;
        }
        
        if (selectionDidChange) {
            gesture.view.center = CGPointMake(gesture.view.center.x,
                                              _bottomRowCellRect.origin.y + cellHeight/2);
            [gesture setTranslation:CGPointMake(0, 0)
                             inView:_tableView];
            CGPoint endPointInRow = CGPointMake(gesture.view.center.x, 0);
            [self updateBackgroundColorForRightDragPoint:endPointInRow];
        }
    }
    
    if ([gesture state] == UIGestureRecognizerStateEnded) {
        _tableView.scrollEnabled = YES;
    }
}

#pragma mark - Update Values

- (void)updateBottomRectValuesWithBottomIndexPath:(NSIndexPath*)bottomIndexPath {
    _bottomIndexPath = [NSIndexPath indexPathForRow:bottomIndexPath.row inSection:0];
    _bottomRowCellRect = [_tableView rectForRowAtIndexPath:bottomIndexPath];
    
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

- (void)updateTopRectValuesWithTopIndexPath:(NSIndexPath*)topIndexPath {
    _topIndexPath = [NSIndexPath indexPathForRow:topIndexPath.row inSection:0];
    _topRowCellRect = [_tableView rectForRowAtIndexPath:topIndexPath];
    
    int topRow = _topIndexPath.row;
    
    if (topRow - 1 >= 0) {
        _nextTopRowIndexPath = [NSIndexPath indexPathForRow:(topRow - 1) inSection:0];
        _nextTopRowCellRect = [_tableView rectForRowAtIndexPath:_nextTopRowIndexPath];
    }
    else {
        _nextTopRowIndexPath = nil;
        _nextTopRowCellRect = CGRectNull;
    }
}

- (void)updateBackgroundColorForRightDragPoint:(CGPoint)endPoint {
    CodeLineCell *cell = (CodeLineCell*)[_tableView cellForRowAtIndexPath:_bottomIndexPath];
    CTLineRef lineRef = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)
                                                         (cell.line));
    endPoint = CGPointMake(endPoint.x - _lineNumberWidthOffSet, endPoint.y);
    CFIndex index = CTLineGetStringIndexForPosition(lineRef, endPoint);
    int endLocation = cell.stringRange.location + index - 1;
    _selectedTextRange = NSMakeRange(_selectedTextRange.location, endLocation - _selectedTextRange.location);
    [_codeViewController setBackgroundColorForString:[UIColor blueColor]
                                           WithRange:_selectedTextRange
                                          forSetting:@"copyAndPaste"];
    [_tableView reloadData];
}

- (void)updateBackgroundColorForLeftDragPoint:(CGPoint)startPoint {
    CodeLineCell *cell = (CodeLineCell*)[_tableView cellForRowAtIndexPath:_topIndexPath];
    CTLineRef lineRef = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)
                                                         (cell.line));
    // FIXME: Left drag point still off by 1 index
    startPoint = CGPointMake(startPoint.x - _lineNumberWidthOffSet, startPoint.y);
    CFIndex index = CTLineGetStringIndexForPosition(lineRef, startPoint);
    int startLocation = cell.stringRange.location + index;
    int newRangeLength = _selectedTextRange.length + _selectedTextRange.location - startLocation;
    _selectedTextRange = NSMakeRange(startLocation, newRangeLength);
    [_codeViewController setBackgroundColorForString:[UIColor blueColor]
                                           WithRange:_selectedTextRange
                                          forSetting:@"copyAndPaste"];
    [_tableView reloadData];
}

- (void)updateLastCharacterValues:(CGPoint)lastCharacterCoordinates {
    _lastCharacterCoordinates = lastCharacterCoordinates;
    
    // Reset prev and next last character coordinates
    [self setLastCharacterCoordinates:lastCharacterCoordinates];
}

#pragma mark - Calculations for character/row rects

- (void)calculateRectValues {
    [self calculateRectValuesForRows];
    [self calculateRectValuesForCharacters];
}

- (void)calculateRectValuesForCharacters {
    _firstCharacterCoordinates = CGPointMake(_leftDragPoint.center.x, 0);
    _lastCharacterCoordinates = CGPointMake(_rightDragPoint.center.x, 0);
    
    
    // TODO: Apply to first character too
    [self setLastCharacterCoordinates:_lastCharacterCoordinates];
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

#pragma mark - Helper Methods

- (void)setLastCharacterCoordinates:(CGPoint)lastCharacterCoordinates {
    CodeLineCell *bottomCell = (CodeLineCell*)[_tableView cellForRowAtIndexPath:_bottomIndexPath];
    CTLineRef bottomLineRef = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)
                                                               (bottomCell.line));
    CFRange stringRangeForBottomRow = CTLineGetStringRange(bottomLineRef);
    CFIndex index = CTLineGetStringIndexForPosition(bottomLineRef, _lastCharacterCoordinates);
    if (index < stringRangeForBottomRow.length) {
        CGFloat offset = CTLineGetOffsetForStringIndex(bottomLineRef, index + 1, NULL);
        _nextLastCharacterCoordinates = CGPointMake(offset, 0);
    }
    else {
        _nextLastCharacterCoordinates = CGPointMake(NAN, NAN);
    }
    
    if (index != 0) {
        CGFloat offset = CTLineGetOffsetForStringIndex(bottomLineRef, index - 1, NULL);
        _previousLastCharacterCoordinates = CGPointMake(offset, 0);
    }
    else {
        _nextLastCharacterCoordinates = CGPointMake(NAN, NAN);
    }
}

#pragma mark - UIGestureRecognizerDelegate Methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
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
