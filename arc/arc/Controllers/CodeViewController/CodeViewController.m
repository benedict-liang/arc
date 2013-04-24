//
//  CodeViewController.m
//  arc
//
//  Created by Benedict Liang on 19/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//
#import <CoreText/CoreText.h>
#import "CodeViewController.h"
#import "CodeLineCell.h"
#import "ApplicationState.h"
#import "ArcAttributedString.h"
#import "FullTextSearch.h"
#import "ResultsTableViewController.h"
#import "DragPointsViewController.h"

@interface CodeViewController ()
@property id<File> currentFile;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ApplicationState *appState;
@property (nonatomic, strong) ArcAttributedString *arcAttributedString;
@property (nonatomic, strong) NSMutableDictionary *sharedObject;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UILabel *toolbarTitle;
@property (nonatomic, strong) UIBarButtonItem *masterViewButton;
@property (nonatomic, strong) UIBarButtonItem *searchButtonIcon;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIPopoverController *resultsPopoverController;
@property (nonatomic, strong) ResultsTableViewController *resultsViewController;
@property (nonatomic, strong) DragPointsViewController *dragPointVC;

@property int lineHeight;
@property int lineNumberWidth;
@property (nonatomic, strong) NSMutableArray *plugins;

// Line Processing
@property (nonatomic) NSMutableArray *lines;
@property (nonatomic) CTTypesetterRef typesetter;

// Folding
@property (nonatomic, strong) FoldTree* foldTree;
@property (nonatomic) BOOL fold;
@property NSMutableDictionary* activeFolds;
@property NSArray* foldStartLines;

- (void)loadFile;
- (void)renderFile;
- (void)clearPreviousLayoutInformation;
- (void)generateLines;
- (void)calcLineHeight;
- (void)execPreRenderPluginsAffectingBounds:(BOOL)affectsBounds
                                   FilterBy:(NSString *)setting;
- (void)execPostRenderPluginsFilterBy:(NSString *)setting;
@end

@implementation CodeViewController
@synthesize delegate = _delegate;

// Code View Delegate Properties
@synthesize backgroundColor = _backgroundColor;
@synthesize foregroundColor = _foregroundColor;
@synthesize selectionColor = _selectionColor;
@synthesize fontFamily = _fontFamily;
@synthesize fontSize = _fontSize;
@synthesize lineNumbers = _lineNumbers;
@synthesize wordWrap = _wordWrap;

- (id)init
{
    self = [super init];
    if (self) {
        _lines = [NSMutableArray array];
        _plugins = [NSMutableArray array];
        _appState = [ApplicationState sharedApplicationState];
        _sharedObject = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.autoresizesSubviews = YES;
    self.view.clipsToBounds = YES;
    
    // Add a toolbar
    _toolbar = [[UIToolbar alloc] initWithFrame:
                CGRectMake(0, 0, self.view.bounds.size.width, SIZE_TOOLBAR_HEIGHT)];
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // Toolbar title
    _toolbarTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, _toolbar.bounds.size.height)];
    _toolbarTitle.backgroundColor = [UIColor clearColor];
    _toolbarTitle.textAlignment = NSTextAlignmentCenter;
    _toolbarTitle.textColor = [UIColor whiteColor];
    _toolbarTitle.font = [UI toolBarTitleFont];
    [_toolbar addSubview:_toolbarTitle];

    [self setUpDefaultToolBar];
    
    [self.view addSubview:_toolbar];
    
    // Set Up TableView
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                              style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.autoresizesSubviews = YES;
    
    // Set TableView's Delegate and DataSource
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self resizeTableView];
    
    [self.view addSubview:_tableView];
}

- (void)resizeTableView
{
    _tableView.frame = CGRectMake(0, SIZE_TOOLBAR_HEIGHT,
                                  self.view.bounds.size.width,
                                  self.view.bounds.size.height - SIZE_TOOLBAR_HEIGHT);
}

- (void)showFile:(id<File>)file
{
    if ([[file identifier] isEqual:[_currentFile identifier]]) {
        return;
    }
    
    if (file == nil) {
        file = _currentFile;
    }
    
    // Update Current file
    _currentFile = file;
    _toolbarTitle.text = [_currentFile name];
    
    // Reset table view scroll position
    [_tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    
    [self loadFile];
    
    _sharedObject = [NSMutableDictionary dictionary];
    _foldTree = nil;
    [self refreshForSetting:nil];
}

- (void)loadFile
{
    _arcAttributedString =
    [[ArcAttributedString alloc]
     initWithString:(NSString *)[_currentFile contents]];
}

- (void)renderFile
{
    // Render Code to screen
    @synchronized(_tableView) {
        [_tableView reloadData];
    }
}

# pragma mark - Change of settings

- (void)refreshForSetting:(NSString *)setting
{
    [self execPreRenderPluginsAffectingBounds:YES FilterBy:setting];
    [self generateLines];
    [self resetFolds];
    [self calcLineHeight];
    [self execPreRenderPluginsAffectingBounds:NO FilterBy:setting];
    [self renderFile];
    [self execPostRenderPluginsFilterBy:setting];
}

# pragma mark - Lines Generation (Code Layout)

- (void)clearPreviousLayoutInformation
{
    if (_typesetter != NULL) {
        CFRelease(_typesetter);
        _typesetter = NULL;
    }

    [_lines removeAllObjects];
    [self dismissTextSelectionViews];
}

- (void)generateLines
{
    [self clearPreviousLayoutInformation];
    
    // Split into Logical Lines
    CGFloat boundsWidth = MAXFLOAT;
    NSMutableDictionary *lineStarts = [NSMutableDictionary dictionary];
    
    // Calculate the lineStarts
    int start = 0;
    int length = _arcAttributedString.string.length;
    
    _typesetter =
    CTTypesetterCreateWithAttributedString
    ((__bridge CFAttributedStringRef)
     _arcAttributedString.plainAttributedString);
    
    int lineNumber = 0;
    while (start < length) {
        lineNumber++;
        [lineStarts setObject:[NSNumber numberWithBool:YES]
                       forKey:[NSNumber numberWithInt:start]];
        CFIndex count = CTTypesetterSuggestLineBreak(_typesetter, start, boundsWidth);
        start += count;
    }
    
    // Split Lines to it bounds
    CGFloat actualBoundsWidth = _tableView.bounds.size.width - SIZE_CODEVIEW_PADDING_AROUND*2;
    if (_lineNumbers) {
        [self calcLineNumberWidthForMaxLineNumber:lineNumber];
        actualBoundsWidth -= _lineNumberWidth;
    }
    
    // Calculate the lines
    start = 0;
    lineNumber = 0;
    CodeViewLine *line;
    while (start < length) {
        CFIndex count = CTTypesetterSuggestLineBreak(_typesetter, start, actualBoundsWidth);
        
        if ([lineStarts objectForKey:[NSNumber numberWithInt:start]]) {
            lineNumber++;
            line = [[CodeViewLine alloc] initWithRange:NSMakeRange(start, count)
                                         AndLineNumber:lineNumber];
        } else {
            line = [[CodeViewLine alloc] initWithRange:NSMakeRange(start, count)];
        }

        [_lines addObject:line];
        start += count;
    }
}

- (void)calcLineNumberWidthForMaxLineNumber:(int)lineNumber
{
    _lineNumberWidth = [CodeLineCell
                           calcLineNumberWidthForMaxLineNumber:lineNumber
                           FontFamily:_fontFamily
                           FontSize:_fontSize];
}

- (void)calcLineHeight
{
    CGFloat asscent, descent, leading;
    if ([_lines count] > 0) {
        CTLineRef line =
        CTLineCreateWithAttributedString
        ((__bridge CFAttributedStringRef)
         ([_arcAttributedString.plainAttributedString
           attributedSubstringFromRange:
           [((CodeViewLine *)[_lines objectAtIndex:0]) range]]));

        CTLineGetTypographicBounds(line, &asscent, &descent, &leading);
        _lineHeight = ceil(asscent + descent + leading);
        _tableView.rowHeight = _lineHeight;

        CFRelease(line);
    }
}

# pragma mark - Code View Delegate

// Strange That this works.
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    _backgroundColor = backgroundColor;
    self.view.backgroundColor = _backgroundColor;
}

- (void)registerPlugin:(id<PluginDelegate>)plugin
{
    // Only register a plugin once.
    if ([_plugins indexOfObject:plugin] == NSNotFound) {
        [_plugins addObject:plugin];
    }
}

- (void)mergeAndRenderWith:(ArcAttributedString *)arcAttributedString
                   forFile:(id<File>)file
                 WithStyle:(NSDictionary *)style
                   AndTree:(FoldTree *)foldTree
{
    if ([[file identifier] isEqual:[_currentFile identifier]]) {
        _arcAttributedString = arcAttributedString;
        _foldTree = foldTree;
        [self resetFolds];
        [self renderFile];
    }
}

- (void)resetFolds
{
    _activeFolds = [NSMutableDictionary dictionary];
    _foldStartLines = [self linesContainingRanges:[_foldTree foldStartRanges]];
    for (CodeViewLine *line in _lines) {
        line.visible = YES;
    }
}

- (void)scrollToLineNumber:(int)lineNumber
{
    int row = 0;
    for (CodeViewLine *codeViewLine in _lines) {
        if (codeViewLine.lineNumber == lineNumber) {
            break;
        }
        row++;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row
                                                inSection:0];
    [_tableView scrollToRowAtIndexPath:indexPath
                      atScrollPosition:UITableViewScrollPositionMiddle
                              animated:NO];
}

- (void)removeBackgroundColorForSetting:(NSString*)setting
{
    [_arcAttributedString removeAttributesForSettingKey:setting];
}

- (void)setBackgroundColorForString:(UIColor*)color
                          WithRange:(NSRange)range
                         forSetting:(NSString*)setting
{
    [_arcAttributedString setBackgroundColor:color
                                     OnRange:range
                                  ForSetting:setting];
}

- (NSString*)getStringForRange:(NSRange)range
{
    return [_arcAttributedString.attributedString.string substringWithRange:range];
}

- (void)redrawCodeViewBoundsChanged:(BOOL)boundsChanged
{
    [self setUpDefaultToolBar];
    [self resizeTableView];
    [self generateLines];
    [self resetFolds];
    [self renderFile];
}

- (id<File>)getCurrentFile {
    return _currentFile;
}

#pragma mark - Execute Plugin Methods

- (void)execPreRenderPluginsAffectingBounds:(BOOL)affectsBounds
                                   FilterBy:(NSString *)setting
{
    NSDictionary *settings;
    for (id<PluginDelegate> plugin in _plugins) {
        if ([plugin affectsBounds] == affectsBounds) {
            if (setting == nil || [[plugin setting] isEqualToString:setting]) {
                settings = [_appState settingsForKeys:@[[plugin setting]]];
                if ([plugin respondsToSelector:
                     @selector(execPreRenderOnArcAttributedString:CodeView:ofFile:forValues:sharedObject:delegate:)])
                {
                    [plugin execPreRenderOnArcAttributedString:_arcAttributedString
                                                      CodeView:self
                                                        ofFile:_currentFile
                                                     forValues:settings
                                                  sharedObject:_sharedObject
                                                      delegate:self];
                }
            }            
        }
    }
}

- (void)execPostRenderPluginsFilterBy:(NSString *)setting
{
    NSDictionary *settings;
    for (id<PluginDelegate> plugin in _plugins) {
        if (setting == nil || [[plugin setting] isEqualToString:setting]) {
            settings = [_appState settingsForKeys:@[[plugin setting]]];
            if ([plugin respondsToSelector:
                 @selector(execPostRenderOnCodeView:ofFile:forValues:sharedObject:delegate:)])
            {
                [plugin execPostRenderOnCodeView:self
                                          ofFile:_currentFile
                                       forValues:settings
                                    sharedObject:_sharedObject
                                        delegate:self];
            }
        }
    }
}

#pragma mark - Tool Bar Methods

- (UIBarButtonItem *)makeMasterViewButton
{
    NSString *title;
    if ([self.delegate masterViewVisible]) {
        title = @"◄◄";
    } else {
        title = @"►►";
    }
    return [[UIBarButtonItem alloc] initWithTitle:title
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(toggleMasterView:)];
}

- (void)setUpDefaultToolBar
{
    _masterViewButton = [self makeMasterViewButton];

    _searchButtonIcon =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                  target:self
                                                  action:@selector(showSearchToolBar)];
    
    [_toolbar setItems:[NSArray arrayWithObjects:
                        _masterViewButton,
                        [Utils flexibleSpace],
                        _searchButtonIcon,
                        nil]];
    
    [UIView animateWithDuration:0.1 animations:^{
        [self centerToolBarTitle];
    }];
}

- (void)showSearchToolBar
{
    // Replace current toolbar with tool bar with search bar
    _searchBar = [[UISearchBar alloc] initWithFrame:
                  CGRectMake(_toolbar.frame.size.width - 250, 0, 200, SIZE_TOOLBAR_HEIGHT)];
    _searchBar.delegate = (id<UISearchBarDelegate>) self;
    UIBarButtonItem *searchBarItem = [[UIBarButtonItem alloc] initWithCustomView:_searchBar];
    
    UIBarButtonItem *doneBarItem =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                  target:self
                                                  action:@selector(hideSearchToolBar)];
    
    [UIView animateWithDuration:0.1 animations:^{
        [self leftAlignToolBarTitle];
    }];

    [_toolbar setItems:[NSArray arrayWithObjects:
                        [Utils flexibleSpace],
                        searchBarItem,
                        doneBarItem,
                        nil]
              animated:YES];
    
    // Initialize results tableview controller
    _resultsViewController = [[ResultsTableViewController alloc] init];
    _resultsViewController.codeViewController = self;
    
    _resultsPopoverController =
    [[UIPopoverController alloc] initWithContentViewController:_resultsViewController];
    
    _resultsPopoverController.passthroughViews =
    [NSArray arrayWithObject:_searchBar];
    [_searchBar becomeFirstResponder];
}

- (void)hideSearchToolBar
{
    [_arcAttributedString removeAttributesForSettingKey:@"search"];
    [_tableView reloadData];

    [self setUpDefaultToolBar];
}

- (void)centerToolBarTitle
{
    _toolbarTitle.textAlignment = NSTextAlignmentCenter;
    _toolbarTitle.frame = CGRectMake(floorf((_toolbar.bounds.size.width - _toolbarTitle.frame.size.width)/2),
                                     0,
                                     _toolbarTitle.frame.size.width,
                                     _toolbar.bounds.size.height);
}

- (void)leftAlignToolBarTitle
{
    _toolbarTitle.textAlignment = NSTextAlignmentLeft;
    _toolbarTitle.frame = CGRectMake(10,
                                     0,
                                     _toolbarTitle.frame.size.width,
                                     _toolbar.bounds.size.height);
}

- (void)toggleMasterView:(id)sender
{
    if ([self.delegate masterViewVisible]) {
        [self.delegate hideMasterViewAnimated:YES];
    } else {
        [self.delegate closedViewController:self];
        [self.delegate showMasterViewAnimated:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    int count = 0;
    for (CodeViewLine *line in _lines) {
        if (line.visible) {
            count++;
        }
    }
    return count;
}

- (CodeViewLine *)lineAtIndexPath:(NSIndexPath *)indexPath
{
    int index = 0;
    @synchronized(_lines) {
        for (CodeViewLine *line in _lines) {
            if (line.visible) {
                if (index == indexPath.row) {
                    return line;
                }
                index++;
            }
        }
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CodeLineCell";
    CodeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[CodeLineCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:cellIdentifier];
    }
    
    [cell setForegroundColor:_foregroundColor];
    [cell setHighlightColor:_selectionColor];    
    [cell setFontFamily:_fontFamily FontSize:_fontSize];
    cell.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    
    CodeViewLine *line = [self lineAtIndexPath:indexPath];
    NSAttributedString *lineRef = [_arcAttributedString.attributedString
                                   attributedSubstringFromRange:line.range];

    // Reset Cell
    [cell resetCell];
    
    cell.showLineNumber = _lineNumbers;
    cell.lineNumberWidth = _lineNumberWidth;
    cell.line = lineRef;
    cell.stringRange = line.range;
    
    if (_lineNumbers) {
        if (line.lineStart) {
            cell.lineNumber = line.lineNumber;
        }
    }

    // Remove Gesture Recognizers
    [Utils removeAllGestureRecognizersFrom:cell.contentView];
    
    // Long Press Gesture for text selection
    UILongPressGestureRecognizer *longPressGesture =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(selectText:)];
    [cell.contentView addGestureRecognizer:longPressGesture];

    // Folding
    if ([_foldStartLines containsObject:[NSNumber numberWithInt:indexPath.row]]) {
        cell.foldStart = YES;
        cell.lineNumberLabel.userInteractionEnabled = YES;
        
        if ([_activeFolds objectForKey:[NSNumber numberWithInt:indexPath.row]]) {
            [cell highlight];

            UITapGestureRecognizer *tapGesture =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(removeFold:)];
            [cell addGestureRecognizer:tapGesture];
        }

        UILongPressGestureRecognizer *longPressGesture =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showFold:)];
        [cell.lineNumberLabel addGestureRecognizer:longPressGesture];
    } else {
        cell.foldStart = NO;
        cell.lineNumberLabel.userInteractionEnabled = NO;
        [Utils removeAllGestureRecognizersFrom:cell.lineNumberLabel];
        [Utils removeAllGestureRecognizersFrom:cell];
    }

    return cell;
}

#pragma mark - Folding

- (void)showFold:(UILongPressGestureRecognizer *)gesture
{
    UIView *v = gesture.view;
    while (![v isKindOfClass:[UITableViewCell class]]) {
        v = v.superview;
    }
    
    CodeLineCell *cell = (CodeLineCell *)v;
    NSIndexPath* indexPath = [_tableView indexPathForCell:cell];
    
    CodeViewLine *codeViewLine = [_lines objectAtIndex:indexPath.row];
    NSDictionary* activeFold = [_foldTree collapsibleLinesForIndex:
                                codeViewLine.range.location + codeViewLine.range.length
                                                         WithLines:_lines];
    
    if (activeFold == nil) {
        return;
    }
    
    NSMutableArray *lines = [activeFold objectForKey:@"lines"];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _fold = YES;
        [cell highlight];
        
        CodeLineCell *foldingCell;
        for (NSNumber *row in lines) {
            foldingCell = (CodeLineCell *)[_tableView cellForRowAtIndexPath:
                                           [NSIndexPath indexPathForItem:[row intValue]
                                                               inSection:0]];
            [foldingCell highlight];
        }
    }
    
    if (gesture.state == UIGestureRecognizerStateCancelled ||
        gesture.state == UIGestureRecognizerStateChanged) {
        _fold = NO;
        [cell removeHighlight];
        
        CodeLineCell *foldingCell;
        for (NSNumber *row in lines) {
            foldingCell = (CodeLineCell *)[_tableView cellForRowAtIndexPath:
                                           [NSIndexPath indexPathForItem:[row intValue]
                                                               inSection:0]];
            [foldingCell removeHighlight];
        }
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (!_fold) {
            return;
        }
        
        NSMutableArray *indexPaths = [NSMutableArray array];
        for (NSNumber *row in lines) {
            [indexPaths addObject:[NSIndexPath indexPathForItem:[row intValue]
                                                      inSection:0]];
        }
        
        NSMutableArray *actualLines = [activeFold objectForKey:@"actualLines"];
        for (NSNumber *row in actualLines) {
            CodeViewLine *line = [_lines objectAtIndex:[row intValue]];
            line.visible = NO;
        }

        [_tableView deleteRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationFade];
        
        [_activeFolds setObject:activeFold
                         forKey:[NSNumber numberWithInt:indexPath.row]];
        
        UITapGestureRecognizer *tapGesture =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(removeFold:)];
        [cell addGestureRecognizer:tapGesture];
    }
}

- (void)removeFold:(UITapGestureRecognizer *)gesture
{
    CodeLineCell *cell = (CodeLineCell *)gesture.view;
    [cell removeHighlight];
    [cell removeGestureRecognizer:gesture];
    NSIndexPath* indexPath = [_tableView indexPathForCell:cell];
    NSDictionary *activeFold = [_activeFolds objectForKey:
                                [NSNumber numberWithInt:indexPath.row]];

    NSMutableArray *lines = [activeFold objectForKey:@"lines"];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (NSNumber *row in lines) {
        CodeViewLine *line = [_lines objectAtIndex:[row intValue]];
        line.visible = YES;
        [indexPaths addObject:[NSIndexPath indexPathForItem:[row intValue]
                                                  inSection:0]];
    }

    [_tableView insertRowsAtIndexPaths:indexPaths
                      withRowAnimation:UITableViewRowAnimationFade];
}

- (NSArray *)linesContainingRanges:(NSArray *)ranges
{
    NSMutableArray* lines = [NSMutableArray array];
    for (int i =0; i < _lines.count; i++) {
        CodeViewLine* line = [_lines objectAtIndex:i];
        NSRange lineRange = line.range;
        for (NSValue* v in ranges) {
            NSRange startRange = [Utils rangeFromValue:v];
            if ([Utils isSubsetOf:lineRange arg:startRange]) {
                [lines addObject:[NSNumber numberWithInt:i]];
            }
        }
    }
    return lines;
}

#pragma mark - Text Selection

- (void)selectText:(UILongPressGestureRecognizer *)gesture
{

    if ([gesture state] == UIGestureRecognizerStateBegan) {
        if (_dragPointVC != nil) {
            [self dismissTextSelectionViews];
        }
        
        UIView *v = gesture.view;
        while (![v isKindOfClass:[UITableViewCell class]]) {
            v = v.superview;
        }
        CodeLineCell *cell = (CodeLineCell*)v;

        // Should only consider point.x
        CGPoint point = [gesture locationInView:_tableView];
        NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    
        // Add drag points subview in CodeViewController
        _dragPointVC = [[DragPointsViewController alloc] initWithIndexPath:indexPath
                                                            withTouchPoint:point
                                                              forTableView:_tableView
                                                         andViewController:self];
        [_tableView addSubview:_dragPointVC.view];
        [_tableView addSubview:_dragPointVC.leftDragPoint];
        [_tableView addSubview:_dragPointVC.rightDragPoint];

        [_tableView reloadData];
    }
}

- (void)dismissTextSelectionViews
{
    if (_dragPointVC != nil) {
        
        [self removeBackgroundColorForSetting:@"copyAndPaste"];
        [_dragPointVC.leftDragPoint removeFromSuperview];
        [_dragPointVC.rightDragPoint removeFromSuperview];
        [_dragPointVC.view removeFromSuperview];
        
        _dragPointVC = nil;
        
        [_tableView reloadData];
    }
}

#pragma mark - Search Bar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchString = [searchBar text];
    NSArray *searchResultRangesArray = [FullTextSearch searchForText:searchString
                                                              inFile:_currentFile];
    NSMutableArray *searchLineNumberArray;
    
    if (searchResultRangesArray != nil) {
        searchLineNumberArray = [[NSMutableArray alloc] init];
        [self getSearchResultLineNumbers:searchLineNumberArray
                        withResultsArray:searchResultRangesArray];
    }
    
    [_arcAttributedString removeAttributesForSettingKey:@"search"];
    for (NSValue *range in searchResultRangesArray) {
        [self setBackgroundColorForString:_selectionColor
                                WithRange:[range rangeValue]
                               forSetting:@"search"];
    }
    
    // Hide keyboard after search button clicked
    [searchBar resignFirstResponder];
    
    // Show results
    _resultsViewController.resultsArray = [NSArray arrayWithArray:searchLineNumberArray];
    [_resultsViewController.tableView reloadData];
    [_resultsPopoverController presentPopoverFromRect:[_searchBar bounds]
                                               inView:_searchBar
                             permittedArrowDirections:UIPopoverArrowDirectionAny
                                             animated:YES];
    
    [_tableView reloadData];
}

- (void)getSearchResultLineNumbers:(NSMutableArray *)searchLineNumberArray
                  withResultsArray:(NSArray *)resultsArray
{    
    for (NSValue *value in resultsArray) {
        NSRange searchResultRange = [value rangeValue];

        int lineNumber = 0;
        for (CodeViewLine *codeViewLine in _lines) {
            if (codeViewLine.lineStart) {
                lineNumber++;
            }
            
            NSRange rangeIntersectionResult =
            NSIntersectionRange(codeViewLine.range, searchResultRange);
            
            // Ranges intersect
            if (rangeIntersectionResult.length != 0) {
                [searchLineNumberArray addObject:[NSNumber numberWithInt:lineNumber]];
                break;
            }
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView
    shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
