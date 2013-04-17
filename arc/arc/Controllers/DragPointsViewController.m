//
//  DragPointsViewController.m
//  arc
//
//  Created by Benedict Liang on 14/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "DragPointsViewController.h"
#import "CodeLineCell.h"

#define KEY_COPY_SETTINGS @"copyAndPaste"
#define DRAG_POINT_WIDTH 55
#define HORIZONTAL_THRESHOLD_PERCENTAGE 0.95
#define VERTICAL_THRESHOLD_PERCENTAGE 0.80

// TODO: Temp magic number
#define PADDING_WIDTH 10

@interface DragPointsViewController ()

@property (nonatomic, strong) CodeViewController *codeViewController;
@property (nonatomic) NSRange selectedTextRange;
@property (nonatomic, strong) UITableView *tableView;

// Cell Index Paths

@property (nonatomic, strong) NSIndexPath *topIndexPath;
@property (nonatomic, strong) NSIndexPath *bottomIndexPath;
@property (nonatomic) CGRect bottomRowCellRect;
@property (nonatomic) CGRect topRowCellRect;

@property (nonatomic) CGRect nextBottomRowCellRect;
@property (nonatomic) CGRect nextTopRowCellRect;
@property (nonatomic, strong) NSIndexPath *nextBottomRowIndexPath;
@property (nonatomic, strong) NSIndexPath *nextTopRowIndexPath;

// Character coordinates
// Convention to follow:
// ______|previous|current|next|__________

@property (nonatomic) CGPoint firstCharacterCoordinates;
@property (nonatomic) CGPoint lastCharacterCoordinates;

@property (nonatomic) CGPoint previousFirstCharacterCoordinates;
@property (nonatomic) CGPoint nextFirstCharacterCoordinates;

@property (nonatomic) CGPoint previousLastCharacterCoordinates;
@property (nonatomic) CGPoint nextLastCharacterCoordinates;

@end

@implementation DragPointsViewController

- (id)initWithIndexPath:(NSIndexPath *)indexPath
         withTouchPoint:(CGPoint)touchPoint
              andOffset:(int)offset
           forTableView:(UITableView *)tableView
      andViewController:(UIViewController *)viewController
{
    self = [super init];
    
    if (self) {
        _topIndexPath = indexPath;
        _bottomIndexPath = indexPath;
        _tableView = tableView;
        _codeViewController = (CodeViewController*)viewController;
        
        CodeLineCell *cell = (CodeLineCell*)[_tableView cellForRowAtIndexPath:indexPath];
        
        // Get global range of selected string (check width of line numbers)
        CTLineRef lineRef = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)
                                                             (cell.line));
        CGPoint adjustedPoint = CGPointMake(touchPoint.x - cell.lineNumberWidth - PADDING_WIDTH, touchPoint.y);
        CFIndex index = CTLineGetStringIndexForPosition(lineRef, adjustedPoint);
        
        // Apply background color for index
        _selectedTextRange = NSMakeRange(cell.stringRange.location + index, 3);
        [self applyBackgroundColorWithSelectedTextRange];
        
        // Get location of touch of tableviewcell in TableView (global)
        CGRect cellRect = [_tableView rectForRowAtIndexPath:indexPath];
        CGFloat startOffset = CTLineGetOffsetForStringIndex(lineRef, index, NULL);
        CGFloat endOffset = CTLineGetOffsetForStringIndex(lineRef, index+3, NULL);
        
        CGRect selectedRect = CGRectMake(startOffset + cell.lineNumberWidth + PADDING_WIDTH,
                                         cellRect.origin.y,
                                         endOffset - startOffset,
                                         cellRect.size.height);
        
        [self createDragPoints:selectedRect];
    }
    
    return self;
}


- (void)createDragPoints:(CGRect)selectedRect
{
    CGRect leftDragPointFrame = CGRectMake(selectedRect.origin.x - DRAG_POINT_WIDTH / 2,
                                           selectedRect.origin.y,
                                           DRAG_POINT_WIDTH,
                                           selectedRect.size.height);
    _leftDragPoint = [[DragPointImageView alloc] initWithFrame:leftDragPointFrame
                                                  andImageName:@"leftDragPoint.png"];
    
    CGRect rightDragPointFrame = CGRectMake(selectedRect.origin.x + selectedRect.size.width - DRAG_POINT_WIDTH / 2,
                                            selectedRect.origin.y,
                                            DRAG_POINT_WIDTH,
                                            selectedRect.size.height);
    _rightDragPoint = [[DragPointImageView alloc] initWithFrame:rightDragPointFrame
                                                   andImageName:@"rightDragPoint.png"];
    
    [self addGestureRecognizersForDragPoints];
}

- (void)addGestureRecognizersForDragPoints
{
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
}

#pragma mark - Drag Points

- (void)moveLeftDragPointHorizontal:(UIPanGestureRecognizer *)gesture
{
    
    [self defaultDragPointGestureRecognizerSetup:gesture];
    
    if ([gesture state] == UIGestureRecognizerStateChanged) {
        
        // Set thresholds
        CGFloat forwardDifference = _nextFirstCharacterCoordinates.x - _firstCharacterCoordinates.x;
        CGFloat backwardDifference = _firstCharacterCoordinates.x - _previousFirstCharacterCoordinates.x;
        CGFloat forwardThreshold = forwardDifference * HORIZONTAL_THRESHOLD_PERCENTAGE;
        CGFloat backwardThreshold = - backwardDifference * HORIZONTAL_THRESHOLD_PERCENTAGE;
        BOOL isDragPointsOverlapping = [self isDragPointsOverlapping:forwardDifference];
        
        CGPoint translation = [gesture translationInView:_tableView];
        BOOL selectionDidChange = NO;
        
        // Select forward
        if (translation.x > forwardThreshold &&
            !isDragPointsOverlapping) {
            [self updateFirstCharacterValues:_nextFirstCharacterCoordinates];
            selectionDidChange = YES;
        }
        
        // Select backward
        if (translation.x < backwardThreshold) {
            [self updateFirstCharacterValues:_previousFirstCharacterCoordinates];
            selectionDidChange = YES;
        }
        
        if (selectionDidChange) {
            CodeLineCell *cell = (CodeLineCell*)[_tableView cellForRowAtIndexPath:_topIndexPath];
            gesture.view.center = CGPointMake(_firstCharacterCoordinates.x + cell.lineNumberWidth + PADDING_WIDTH,
                                              gesture.view.center.y);
            [gesture setTranslation:CGPointMake(0, 0)
                             inView:_tableView];
            CGPoint startPointInRow = CGPointMake(gesture.view.center.x, 0);
            [self updateBackgroundColorForLeftDragPointHorizontal:startPointInRow];
        }
    }
}

- (void)moveLeftDragPointVertical:(UIPanGestureRecognizer *)gesture
{
    [self defaultDragPointGestureRecognizerSetup:gesture];
    
    if ([gesture state] == UIGestureRecognizerStateChanged) {
        
        // Set thresholds
        CGFloat cellHeight = _topRowCellRect.size.height;
        CGFloat threshold = cellHeight * VERTICAL_THRESHOLD_PERCENTAGE;
        
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
            CodeLineCell *cell = (CodeLineCell*)[_tableView cellForRowAtIndexPath:_topIndexPath];
            gesture.view.center = CGPointMake(cell.lineNumberWidth + PADDING_WIDTH,
                                              _topRowCellRect.origin.y + cellHeight/2);
            [gesture setTranslation:CGPointMake(0, 0)
                             inView:_tableView];
            CGPoint startPointInRow = CGPointMake(gesture.view.center.x, 0);
            [self updateBackgroundColorForLeftDragPointVertical:startPointInRow];
        }
    }
}

- (void)moveRightDragPointHorizontal:(UIPanGestureRecognizer *)gesture
{
    [self defaultDragPointGestureRecognizerSetup:gesture];
    
    if ([gesture state] == UIGestureRecognizerStateChanged) {
        
        // Set thresholds
        CGFloat forwardDifference = _nextLastCharacterCoordinates.x - _lastCharacterCoordinates.x;
        CGFloat backwardDifference = _lastCharacterCoordinates.x - _previousLastCharacterCoordinates.x;
        CGFloat forwardThreshold = forwardDifference * HORIZONTAL_THRESHOLD_PERCENTAGE;
        CGFloat backwardThreshold = - backwardDifference * HORIZONTAL_THRESHOLD_PERCENTAGE;
        BOOL isDragPointsOverlapping = [self isDragPointsOverlapping:forwardDifference];
        
        CGPoint translation = [gesture translationInView:_tableView];
        BOOL selectionDidChange = NO;
        
        // Select forward
        if (translation.x > forwardThreshold) {
            [self updateLastCharacterValues:_nextLastCharacterCoordinates];
            selectionDidChange = YES;
        }
        
        // Select backward
        if (translation.x < backwardThreshold &&
            !isDragPointsOverlapping) {
            [self updateLastCharacterValues:_previousLastCharacterCoordinates];
            selectionDidChange = YES;
        }
        
        if (selectionDidChange) {
            CodeLineCell *cell = (CodeLineCell*)[_tableView cellForRowAtIndexPath:_bottomIndexPath];
            gesture.view.center = CGPointMake(_lastCharacterCoordinates.x + cell.lineNumberWidth + PADDING_WIDTH,
                                              gesture.view.center.y);
            [gesture setTranslation:CGPointMake(0, 0) inView:_tableView];
            CGPoint endPointInRow = CGPointMake(gesture.view.center.x, 0);
            [self updateBackgroundColorForRightDragPointHorizontal:endPointInRow];
        }
    }
}

- (void)moveRightDragPointVertical:(UIPanGestureRecognizer *)gesture
{
    [self defaultDragPointGestureRecognizerSetup:gesture];
    
    if ([gesture state] == UIGestureRecognizerStateChanged) {
        
        // Set thresholds
        CGFloat cellHeight = _bottomRowCellRect.size.height;
        CGFloat threshold = cellHeight * VERTICAL_THRESHOLD_PERCENTAGE;
        
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
            CodeLineCell *cell = (CodeLineCell*)[_tableView cellForRowAtIndexPath:_bottomIndexPath];
            CGPoint endOfLineCoordinates = [self getLastCharacterCoordinatesInRow:_bottomIndexPath];
            gesture.view.center = CGPointMake(endOfLineCoordinates.x + cell.lineNumberWidth + PADDING_WIDTH,
                                              _bottomRowCellRect.origin.y + cellHeight/2);
            [gesture setTranslation:CGPointMake(0, 0)
                             inView:_tableView];
            CGPoint endPointInRow = CGPointMake(gesture.view.center.x, 0);
            [self updateBackgroundColorForRightDragPointVertical:endPointInRow];
        }
    }
}

- (void)defaultDragPointGestureRecognizerSetup:(UIPanGestureRecognizer *)gesture
{
    if ([gesture state] == UIGestureRecognizerStateBegan) {
        [self calculateRectValues];
        _tableView.scrollEnabled = NO;
    }
    
    if ([gesture state] == UIGestureRecognizerStateEnded) {
        _tableView.scrollEnabled = YES;
        [self showCopyMenuForTextSelection];
    }
}

#pragma mark - Update Values

- (void)updateBottomRectValuesWithBottomIndexPath:(NSIndexPath *)bottomIndexPath
{
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

- (void)updateTopRectValuesWithTopIndexPath:(NSIndexPath *)topIndexPath
{
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

- (void)updateFirstCharacterValues:(CGPoint)firstCharacterCoordinates
{
    _firstCharacterCoordinates = firstCharacterCoordinates;
    
    // Reset prev and next last character coordinates
    [self setFirstCharacterCoordinates:_firstCharacterCoordinates];
}

- (void)updateLastCharacterValues:(CGPoint)lastCharacterCoordinates
{
    _lastCharacterCoordinates = lastCharacterCoordinates;
    
    // Reset prev and next last character coordinates
    [self setLastCharacterCoordinates:_lastCharacterCoordinates];
}

#pragma mark - Update Background Color for Drag Points

- (void)updateBackgroundColorForLeftDragPointHorizontal:(CGPoint)startPoint
{
    [self updateSelectedTextRangeForLeftDragPoint:startPoint];
    [self applyBackgroundColorWithSelectedTextRangeForRow:_topIndexPath];
}

- (void)updateBackgroundColorForLeftDragPointVertical:(CGPoint)startPoint
{
    [self updateSelectedTextRangeForLeftDragPoint:startPoint];
    [self applyBackgroundColorWithSelectedTextRange];
}

- (void)updateSelectedTextRangeForLeftDragPoint:(CGPoint)startPoint
{
    CodeLineCell *cell = (CodeLineCell*)[_tableView cellForRowAtIndexPath:_topIndexPath];
    CTLineRef lineRef = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)
                                                         (cell.line));
    startPoint = CGPointMake(startPoint.x - cell.lineNumberWidth - PADDING_WIDTH, startPoint.y);
    CFIndex index = CTLineGetStringIndexForPosition(lineRef, startPoint);
    int startLocation = cell.stringRange.location + index;
    
    int newRangeLength = _selectedTextRange.length + _selectedTextRange.location - startLocation;
    _selectedTextRange = NSMakeRange(startLocation, newRangeLength);
}

- (void)updateBackgroundColorForRightDragPointHorizontal:(CGPoint)startPoint
{
    [self updateSelectedTextRangeForRightDragPoint:startPoint];
    [self applyBackgroundColorWithSelectedTextRangeForRow:_bottomIndexPath];
}

- (void)updateBackgroundColorForRightDragPointVertical:(CGPoint)startPoint
{
    [self updateSelectedTextRangeForRightDragPoint:startPoint];
    [self applyBackgroundColorWithSelectedTextRange];
}

- (void)updateSelectedTextRangeForRightDragPoint:(CGPoint)endPoint
{
    CodeLineCell *cell = (CodeLineCell*)[_tableView cellForRowAtIndexPath:_bottomIndexPath];
    CTLineRef lineRef = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)
                                                         (cell.line));
    endPoint = CGPointMake(endPoint.x - cell.lineNumberWidth - PADDING_WIDTH, endPoint.y);
    CFIndex index = CTLineGetStringIndexForPosition(lineRef, endPoint);
    int endLocation = cell.stringRange.location + index;
    
    int newRangeLength = endLocation - _selectedTextRange.location;
    _selectedTextRange = NSMakeRange(_selectedTextRange.location, newRangeLength);
}

#pragma mark - Apply and Render Background Color

- (void)applyBackgroundColorWithSelectedTextRange
{
    [_codeViewController removeBackgroundColorForSetting:KEY_COPY_SETTINGS];
    [_codeViewController setBackgroundColorForString:[UIColor blueColor]
                                           WithRange:_selectedTextRange
                                          forSetting:KEY_COPY_SETTINGS];
    
    for (int i=_topIndexPath.row; i<=_bottomIndexPath.row; i++) {
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:
                                            [NSIndexPath indexPathForRow:i inSection:0]]
                          withRowAnimation:UITableViewRowAnimationNone];
    }
    
    if (_nextBottomRowIndexPath != nil) {
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:_nextBottomRowIndexPath]
                          withRowAnimation:UITableViewRowAnimationNone];
    }
    
    if (_nextTopRowIndexPath != nil) {
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:_nextTopRowIndexPath]
                          withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)applyBackgroundColorWithSelectedTextRangeForRow:(NSIndexPath *)indexPath
{
    [_codeViewController removeBackgroundColorForSetting:KEY_COPY_SETTINGS];
    [_codeViewController setBackgroundColorForString:[UIColor blueColor]
                                           WithRange:_selectedTextRange
                                          forSetting:KEY_COPY_SETTINGS];
    
    if (_nextTopRowIndexPath != nil) {
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                          withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - Calculations for character/row rects

- (void)calculateRectValues
{
    [self calculateRectValuesForRows];
    [self calculateRectValuesForCharacters];
}

- (void)calculateRectValuesForCharacters
{
    _firstCharacterCoordinates = CGPointMake(_leftDragPoint.center.x, 0);
    _lastCharacterCoordinates = CGPointMake(_rightDragPoint.center.x, 0);
    
    [self setFirstCharacterCoordinates:_firstCharacterCoordinates];
    [self setLastCharacterCoordinates:_lastCharacterCoordinates];
}

- (void)calculateRectValuesForRows
{
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

#pragma mark - UIMenuController Methods

- (void)showCopyMenuForTextSelection
{
    if ([self becomeFirstResponder]) {
        //NSLog(@"is first responder");
    }
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    UIMenuItem *copyMenuItem = [[UIMenuItem alloc] initWithTitle:@"copy" action:@selector(copyString:)];
    [menuController setMenuItems:[NSArray arrayWithObject:copyMenuItem]];
    [menuController setTargetRect:_topRowCellRect inView:_tableView];
    
    [menuController setMenuVisible:YES animated:YES];
}

#pragma mark - Helper Methods

- (void)setFirstCharacterCoordinates:(CGPoint)firstCharacterCoordinates
{
    CodeLineCell *topCell = (CodeLineCell*)[_tableView cellForRowAtIndexPath:_topIndexPath];
    CTLineRef topLineRef = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)
                                                            (topCell.line));
    CFRange stringRangeForTopRow = CTLineGetStringRange(topLineRef);
    CFIndex index = CTLineGetStringIndexForPosition(topLineRef, _firstCharacterCoordinates);
    if (index < stringRangeForTopRow.length) {
        CGFloat offset = CTLineGetOffsetForStringIndex(topLineRef, index + 1, NULL);
        _nextFirstCharacterCoordinates = CGPointMake(offset, 0);
    }
    else {
        _nextFirstCharacterCoordinates = CGPointMake(NAN, NAN);
    }
    
    if (index != 0) {
        CGFloat offset = CTLineGetOffsetForStringIndex(topLineRef, index - 1, NULL);
        _previousFirstCharacterCoordinates = CGPointMake(offset, 0);
    }
    else {
        _previousFirstCharacterCoordinates = CGPointMake(NAN, NAN);
    }
}

- (void)setLastCharacterCoordinates:(CGPoint)lastCharacterCoordinates
{
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

- (BOOL)isDragPointsOverlapping:(CGFloat)characterWidth
{
    return
    (_topIndexPath.row == _bottomIndexPath.row) &&
    ((_lastCharacterCoordinates.x - _firstCharacterCoordinates.x) < characterWidth * 2);
}

#pragma mark - UIGestureRecognizerDelegate Methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)copyString:(id)sender
{
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    NSString *copiedString = [_codeViewController getStringForRange:_selectedTextRange];
    [pasteBoard setString:copiedString];
    
    [_codeViewController dismissTextSelectionViews];
}

#pragma mark - Misc Methods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint locationPoint = [[touches anyObject] locationInView:_tableView];
    UIView *view = [_tableView hitTest:locationPoint withEvent:event];
    if (view != _leftDragPoint || view != _rightDragPoint) {
        [_codeViewController dismissTextSelectionViews];
    }
}

- (CGPoint)getLastCharacterCoordinatesInRow:(NSIndexPath *)indexPath
{
    CodeLineCell *cell = (CodeLineCell*)[_tableView cellForRowAtIndexPath:indexPath];
    CTLineRef lineRef = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)
                                                         (cell.line));
    CFRange stringRangeForRow = CTLineGetStringRange(lineRef);
    
    if (stringRangeForRow.length == 1) {
        return CGPointMake(cell.lineNumberWidth, 0);
    }
    else {
        CGFloat offset = CTLineGetOffsetForStringIndex(lineRef, stringRangeForRow.length, NULL);
        return CGPointMake(offset, 0);
    }
}

- (BOOL)canBecomeFirstResponder
{
    // NOTE: This menu item will not show if this is not YES!
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
