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

#define KEY_RANGE @"range"
#define KEY_LINE_NUMBER @"lineNumber"
#define KEY_LINE_START @"lineStart"

@interface CodeViewController ()
@property id<File> currentFile;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ApplicationState *appState;
@property (nonatomic, strong) ArcAttributedString *arcAttributedString;
@property (nonatomic, strong) NSMutableDictionary *sharedObject;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIBarButtonItem *toolbarTitle;
@property (nonatomic, strong) UIBarButtonItem *portraitButton;
@property (nonatomic, strong) UIBarButtonItem *searchButtonIcon;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIPopoverController *resultsPopoverController;
@property (nonatomic, strong) ResultsTableViewController *resultsViewController;
@property (nonatomic, strong) DragPointsViewController *dragPointVC;
@property CGFloat lineHeight;
@property NSMutableArray *plugins;

// Line Processing
@property (nonatomic) BOOL linesGenerated;
@property (nonatomic) NSMutableArray *lines;
@property (nonatomic) int cursor;
@property (nonatomic) CTTypesetterRef typesetter;

// Folding
@property FoldTree* foldTree;
@property ArcAttributedString* buffer;
@property NSArray* foldedLines;

- (void)loadFile;
- (void)renderFile;
- (void)clearPreviousLayoutInformation;
- (void)generateLines;
- (void)calcLineHeight;
@end

@implementation CodeViewController
@synthesize delegate = _delegate;

// Code View Delegate Properties
@synthesize backgroundColor = _backgroundColor;
@synthesize foregroundColor = _foregroundColor;
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
        
        // Defaults
        _backgroundColor = [Utils colorWithHexString:@"FDF6E3"];
        _sharedObject = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.autoresizesSubviews = YES;
    
    // Add a toolbar
    _toolbar = [[UIToolbar alloc] initWithFrame:
                CGRectMake(0, 0, self.view.bounds.size.width, SIZE_TOOLBAR_HEIGHT)];
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [self setUpDefaultToolBar];
    
    [self.view addSubview:_toolbar];
    
    // Set Up TableView
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                              style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleWidth;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.autoresizesSubviews = YES;
    
    // Set TableView's Delegate and DataSource
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.frame = CGRectMake(0, SIZE_TOOLBAR_HEIGHT,
                                  self.view.bounds.size.width,
                                  self.view.bounds.size.height - SIZE_TOOLBAR_HEIGHT);
    
    [self.view addSubview:_tableView];
}

- (void)showFile:(id<File>)file
{
    if ([[file path] isEqual:[_currentFile path]]) {
        return;
    }
    
    // Update Current file
    _currentFile = file;
    _toolbarTitle.title = [_currentFile name];
    
    // Reset table view scroll position
    [_tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    
    [self loadFile];
    
    _sharedObject = [NSMutableDictionary dictionary];
    _linesGenerated = NO;

    [self preRenderPluginsForSetting:nil];
    [self generateLines];
    [self calcLineHeight];
    [self renderFile];
    [self postRenderPluginsForSetting:nil];
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
    [_tableView reloadData];
}

# pragma mark - Change of settings

- (void)refreshForSetting:(NSString *)setting
{
    id<PluginDelegate> plugin = [self findPluginForSettingKey:setting];

    if ([plugin settingKeyAffectsBounds:setting]) {
        _linesGenerated = NO;
        [self preRenderPluginsForSetting:setting];
        [self generateLines];
        [self calcLineHeight];
    } else {
        [self preRenderPluginsForSetting:setting];
    }
    
    [self renderFile];
    [self postRenderPluginsForSetting:setting];
}

- (id<PluginDelegate>)findPluginForSettingKey:(NSString *)settingKey
{
    for (id<PluginDelegate> plugin in _plugins) {
        if ([[plugin settingKeys] indexOfObject:settingKey] != NSNotFound) {
            return plugin;
        }
    }
    return nil;
}

# pragma mark - Lines Generation (Code Layout)

- (void)clearPreviousLayoutInformation
{
    if (_typesetter != NULL) {
        CFRelease(_typesetter);
        _typesetter = NULL;
    }
    
    _lines = [NSMutableArray array];
    _cursor = 0;
}

- (void)generateLines
{
    [self clearPreviousLayoutInformation];
    
    NSArray *keys = [NSArray arrayWithObjects:
                     KEY_RANGE,
                     KEY_LINE_NUMBER,
                     KEY_LINE_START,
                     nil];
    
    // Split into Logical Lines
    CGFloat boundsWidth = MAXFLOAT;
    NSMutableDictionary *lineStarts = [NSMutableDictionary dictionary];
    
    // Calculate the lineStarts
    int start = 0;
    int length = _arcAttributedString.string.length;
    
    _typesetter = CTTypesetterCreateWithAttributedString((__bridge CFAttributedStringRef)_arcAttributedString.plainAttributedString);
    
    while (start < length) {
        [lineStarts setObject:[NSNumber numberWithBool:YES]
                       forKey:[NSNumber numberWithInt:start]];
        CFIndex count = CTTypesetterSuggestLineBreak(_typesetter, start, boundsWidth);
        start += count;
    }
    
    // Split Lines to it bounds
    CGFloat actualBoundsWidth = _tableView.bounds.size.width - 20*2 - 45;
    
    // Calculate the lines
    start = 0;
    int lineNumber = 0;
    BOOL startOfLine;
    while (start < length) {
        if ([lineStarts objectForKey:[NSNumber numberWithInt:start]]) {
            lineNumber++;
            startOfLine = YES;
        } else {
            startOfLine = NO;
        }
        
        CFIndex count = CTTypesetterSuggestLineBreak(_typesetter, start, actualBoundsWidth);
        [_lines addObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:
                                                               [NSValue valueWithRange:NSMakeRange(start, count)],
                                                               [NSNumber numberWithInt:lineNumber],
                                                               [NSNumber numberWithBool:startOfLine],
                                                               nil]
                                                      forKeys:keys]];
        start += count;
    }
    _linesGenerated = YES;
    
}

- (void)calcLineHeight
{
    CGFloat asscent, descent, leading;
    if ([_lines count] > 0) {
        CTLineRef line = CTLineCreateWithAttributedString(
                                                          (__bridge CFAttributedStringRef)(
                                                                                           [_arcAttributedString.plainAttributedString attributedSubstringFromRange:
                                                                                            [[[_lines objectAtIndex:0] objectForKey:KEY_RANGE] rangeValue]]));

        CTLineGetTypographicBounds(line, &asscent, &descent, &leading);
        _lineHeight = asscent + descent + leading;
        _tableView.rowHeight = ceil(_lineHeight);
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
    if ([[file path] isEqual:[_currentFile path]]) {
        _arcAttributedString = arcAttributedString;
        _foldTree = foldTree;
        
        if (!_linesGenerated) {
            [self generateLines];
        }
        
        [self renderFile];
    }
}

- (void)scrollToLineNumber:(int)lineNumber
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lineNumber
                                                inSection:0];
    [_tableView scrollToRowAtIndexPath:indexPath
                      atScrollPosition:UITableViewScrollPositionMiddle
                              animated:YES];
}

- (void)removeBackgroundColorForSetting:(NSString*)setting {
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

- (NSString*)getStringForRange:(NSRange)range {
    return [_arcAttributedString.attributedString.string substringWithRange:range];
}

#pragma mark - Execute Plugin Methods

- (void)preRenderPluginsForSetting:(NSString *)setting
{
    NSDictionary *settings;
    for (id<PluginDelegate> plugin in _plugins) {
        NSArray *settingKeys = [plugin settingKeys];
        if (setting == nil || [settingKeys indexOfObject:setting] != NSNotFound) {
            settings = [_appState settingsForKeys:settingKeys];
            if ([plugin respondsToSelector:
                 @selector(execOnArcAttributedString:ofFile:forValues:sharedObject:delegate:)])
            {
                [plugin execOnArcAttributedString:_arcAttributedString
                                           ofFile:_currentFile
                                        forValues:settings
                                     sharedObject:_sharedObject
                                         delegate:self];
            }
        }
    }
}


- (void)postRenderPluginsForSetting:(NSString *)setting
{
    NSDictionary *settings;
    for (id<PluginDelegate> plugin in _plugins) {
        NSArray *settingKeys = [plugin settingKeys];
        if (setting == nil || [settingKeys indexOfObject:setting] != NSNotFound) {
            settings = [_appState settingsForKeys:settingKeys];
            if ([plugin respondsToSelector:
                 @selector(execOnCodeView:ofFile:forValues:sharedObject:delegate:)])
            {
                [plugin execOnCodeView:self
                                ofFile:_currentFile
                             forValues:settings
                          sharedObject:_sharedObject
                              delegate:self];
            }
        }
    }
}

#pragma mark - Tool Bar Methods

- (void)setUpDefaultToolBar
{
    _toolbarTitle = [[UIBarButtonItem alloc] initWithTitle:[_currentFile name]
                                                     style:UIBarButtonItemStylePlain
                                                    target:nil
                                                    action:nil];
    _searchButtonIcon =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                  target:self
                                                  action:@selector(showSearchToolBar)];
    
    [_toolbar setItems:[NSArray arrayWithObjects:
                        [Utils flexibleSpace],
                        _toolbarTitle,
                        [Utils flexibleSpace],
                        _searchButtonIcon,
                        nil]];
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
    [_toolbar setItems:[NSArray arrayWithObjects:
                        _toolbarTitle,
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
    
    if (UIDeviceOrientationIsLandscape(self.interfaceOrientation))
    {
        [self setUpDefaultToolBar];
    }
    else {
        [self showShowMasterViewButton:_portraitButton];
    }
}

#pragma mark - Detail View Controller Delegate

- (void)showShowMasterViewButton:(UIBarButtonItem *)button
{
    // Customise the button.
    UIImage *icon = [Utils scale:[UIImage imageNamed:@"threelines.png"]
                          toSize:CGSizeMake(40, SIZE_TOOLBAR_ICON_WIDTH)];
    [button setImage:icon];
    [button setStyle:UIBarButtonItemStylePlain];
    [button setTitle:nil];
    
    _toolbar.items = [NSArray arrayWithObjects:
                      button,
                      [Utils flexibleSpace],
                      _toolbarTitle,
                      [Utils flexibleSpace],
                      _searchButtonIcon,
                      nil];
    _portraitButton = button;
}

- (void)hideShowMasterViewButton:(UIBarButtonItem *)button
{
    [self setUpDefaultToolBar];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [_lines count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString *cellIdentifier = @"CodeLineCell";
    CodeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[CodeLineCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:cellIdentifier];
    }
    
    [cell setForegroundColor:_foregroundColor];
    [cell setFontFamily:_fontFamily FontSize:_fontSize];
    cell.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    NSDictionary *lineObject = (NSDictionary *)[_lines objectAtIndex:indexPath.row];
    NSRange stringRange = [[lineObject objectForKey:KEY_RANGE] rangeValue];
    NSAttributedString *lineRef = [_arcAttributedString.attributedString attributedSubstringFromRange:
                                   stringRange];
    
    cell.line = lineRef;
    cell.stringRange = stringRange;

    NSInteger lineNumber = [[lineObject objectForKey:KEY_LINE_NUMBER] integerValue];
    
    if (_lineNumbers) {
        if ([[lineObject objectForKey:KEY_LINE_START] boolValue]) {
            cell.lineNumber = lineNumber;
        }
    }

    // Remove Gesture Recognizers
    for (UIGestureRecognizer *g in [cell gestureRecognizers]) {
        [cell removeGestureRecognizer:g];
    }
    if ([_foldedLines containsObject:[NSNumber numberWithInt:indexPath.row]]) {
        cell.hidden = YES;
        return cell;
    }
    // Long Press Gesture for text selection
    UILongPressGestureRecognizer *longPressGesture =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(selectText:)];
    [cell addGestureRecognizer:longPressGesture];
    
    UITapGestureRecognizer *doubleTapGesture =
    [[UITapGestureRecognizer alloc]
     initWithTarget:self
     action:@selector(foldForGesture:)];
    
    doubleTapGesture.numberOfTapsRequired = 2;
    
    [cell addGestureRecognizer:doubleTapGesture];
    [cell setNeedsDisplay];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_foldedLines containsObject:[NSNumber numberWithInt:indexPath.row]]) {
        return 0;
    }
    return 20;
}
- (void)selectText:(UILongPressGestureRecognizer*)gesture {
    
    if ([gesture state] == UIGestureRecognizerStateBegan) {
        if (_dragPointVC != nil) {
            [self dismissTextSelectionViews];
        }
        
        CodeLineCell *cell = (CodeLineCell*)gesture.view;
        NSAttributedString *attributedString = cell.line;
        NSRange cellStringRange = cell.stringRange;
        int lineNumberWidth = cell.lineNumberWidth;
        
        // Should only consider point.x
        CGPoint point = [gesture locationInView:gesture.view];
        
        // Get global range of selected string (check width of line numbers)
        CTLineRef lineRef = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)
                                                             (attributedString));
        CFIndex index = CTLineGetStringIndexForPosition(lineRef, point);

        // Apply background color for index
        NSRange selectedRange = NSMakeRange(cellStringRange.location + index, 3);
        [self setBackgroundColorForString:[UIColor blueColor]
                                WithRange:selectedRange
                               forSetting:@"copyAndPaste"];
        
        // Get location of touch of tableviewcell in TableView (global)
        NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
        CGRect cellRect = [_tableView rectForRowAtIndexPath:indexPath];
        CGFloat startOffset = CTLineGetOffsetForStringIndex(lineRef, index, NULL);
        CGFloat endOffset = CTLineGetOffsetForStringIndex(lineRef, index+3, NULL);

        CGRect selectedRect = CGRectMake(cellRect.origin.x + startOffset, cellRect.origin.y,
                                        endOffset - startOffset, cellRect.size.height);
    
        // Add drag points subview in CodeViewController
        _dragPointVC = [[DragPointsViewController alloc] initWithSelectedTextRect:selectedRect
                                                                        andOffset:lineNumberWidth];
        _dragPointVC.topIndexPath = indexPath;
        _dragPointVC.bottomIndexPath = indexPath;
        _dragPointVC.tableView = _tableView;
        _dragPointVC.codeViewController = self;
        _dragPointVC.selectedTextRange = selectedRange;
        
        [_tableView addSubview:_dragPointVC.view];
        [_tableView addSubview:_dragPointVC.leftDragPoint];
        [_tableView addSubview:_dragPointVC.rightDragPoint];

        [_tableView reloadData];
    }
    if ([gesture state] == UIGestureRecognizerStateEnded) {

    }
}

- (void)dismissTextSelectionViews {
    if (_dragPointVC != nil) {
        
        [self removeBackgroundColorForSetting:@"copyAndPaste"];
        [_dragPointVC.leftDragPoint removeFromSuperview];
        [_dragPointVC.rightDragPoint removeFromSuperview];
        [_dragPointVC.view removeFromSuperview];
        
        _dragPointVC = nil;
        
        [_tableView reloadData];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView*)tableView
didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];
}

#pragma mark - Search Bar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar
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
        [self setBackgroundColorForString:[UIColor yellowColor]
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
    int lineIndex = 0;
    
    for (int i=0; i<[resultsArray count]; i++) {
        NSRange searchResultRange = [[resultsArray objectAtIndex:i] rangeValue];
        
        for (int j=lineIndex; j<[_lines count]; j++) {
            NSRange lineRange = [[[_lines objectAtIndex:j] objectForKey:KEY_RANGE] rangeValue];
            NSRange rangeIntersectionResult = NSIntersectionRange(lineRange, searchResultRange);
            
            // Ranges intersect
            if (rangeIntersectionResult.length != 0) {
                
                [searchLineNumberArray addObject:[NSNumber numberWithInt:j]];
                
                // Update current lineIndex
                lineIndex = j;
                break;
            }
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - Folding
- (void)foldForGesture:(UIGestureRecognizer*)gesture {
    CFIndex index = [self indexOfStringAtGesture:gesture];
    NSRange subtractRange = [_foldTree lowestNodeWithIndex:index];
    NSLog(@"%@",[NSValue value:&subtractRange withObjCType:@encode(NSRange)]);
    _foldedLines = [self foldedLinesForRange:subtractRange];
    //[self swapArcAttributedStringWith:[_arcAttributedString arcStringWithRemovedRange:subtractRange]];
    [self renderFile];
}
- (NSArray*)foldedLinesForRange:(NSRange)subtractRange {
    NSMutableArray *hideCells = [NSMutableArray array];
    for(int i =0 ;i < _lines.count; i++) {
        NSDictionary* line = [_lines objectAtIndex:i];
        NSRange lineRange;
        [(NSValue*)[line objectForKey:KEY_RANGE] getValue:&lineRange];
        if ([Utils isSubsetOf:subtractRange arg:lineRange]) {
            [hideCells addObject:[NSNumber numberWithInt:i]];
        }
    }
    return hideCells;
}

- (void)swapArcAttributedStringWith:(ArcAttributedString*)newArcString {
    _buffer = _arcAttributedString;
    _arcAttributedString = newArcString;
    [self generateLines];
    [self calcLineHeight];
    [self renderFile];
}
- (CFIndex)indexOfStringAtGesture:(UIGestureRecognizer*)gesture {
    CodeLineCell *cell = (CodeLineCell*)[gesture view];

    NSIndexPath* cellIndex = [(UITableView*)cell.superview indexPathForCell:cell];
    NSDictionary* lineDict = [_lines objectAtIndex:cellIndex.row];
    CGPoint pointOfTouch = [gesture locationInView:cell];
    
    NSAttributedString *line = cell.line;
    CTLineRef lineref = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)(line));
    CFIndex subIndex = CTLineGetStringIndexForPosition(lineref, pointOfTouch);
    
    NSRange cellRange;
    [(NSValue*)[lineDict objectForKey:KEY_RANGE] getValue:&cellRange];
    CFIndex selectedIndex =  cellRange.location + subIndex;
     NSLog(@"cellIndex: %@, range:%@ selectedIndex:%ld",cellIndex,[lineDict objectForKey:KEY_RANGE], selectedIndex);
    return selectedIndex;
}

@end
