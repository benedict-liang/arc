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
@property CTFramesetterRef frameSetter;
@property CGFloat lineHeight;
@property NSMutableArray *lines;
@property NSMutableArray *plugins;

- (void)loadFile;
- (void)renderFile;
- (void)clearPreviousLayoutInformation;
- (void)generateLines;
- (void)calcLineHeight;
@end

@implementation CodeViewController
@synthesize delegate = _delegate;
@synthesize backgroundColor = _backgroundColor;

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
    _tableView.backgroundColor = _backgroundColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.autoresizesSubviews = YES;
    
    // Set TableView's Delegate and DataSource
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.frame = CGRectMake(0, SIZE_TOOLBAR_HEIGHT,
                                  self.view.bounds.size.width,
                                  self.view.bounds.size.height - SIZE_TOOLBAR_HEIGHT);
    
    // TODO: Remove once confirmed - search bar on top of code
    //[self addSearchBarToTableViewTop];
    
    [self.view addSubview:_tableView];
}

- (void)refreshForSetting:(NSString *)setting
{
    [self processFileForSetting:setting];
}

- (void)showFile:(id<File>)file
{
    if ([file isEqual:_currentFile]) {
        [_tableView reloadData];
        return;
    }
    
    // Update Current file
    _currentFile = file;
    [self updateToolbarTitle];
    
    [self loadFile];
    [self processFileForSetting:nil];
}

- (void)processFileForSetting:(NSString*)setting
{
    _sharedObject = [NSMutableDictionary dictionary];
    
    [self preRenderPluginsForSetting:setting];
    [self generateLines];
    [self calcLineHeight];
    [self renderFile];
    [self postRenderPluginsForSetting:setting];
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

- (void)updateToolbarTitle
{
    _toolbarTitle.title = [_currentFile name];
}

- (void)clearPreviousLayoutInformation
{
    if (_frameSetter != NULL) {
        CFRelease(_frameSetter);
        _frameSetter = NULL;
    }
    
    _lines = [NSMutableArray array];
}

- (void)generateLines
{
    [self clearPreviousLayoutInformation];
    _lines = [NSMutableArray array];
    
    CFAttributedStringRef ref =
    (CFAttributedStringRef)CFBridgingRetain(_arcAttributedString.plainAttributedString);
    _frameSetter = CTFramesetterCreateWithAttributedString(ref);
    
    // Work out the geometry
    CGFloat boundsWidth = _tableView.bounds.size.width - 20*2 - 45;
    
    // Calculate the lines
    CFIndex start = 0;
    NSUInteger length = CFAttributedStringGetLength(ref);
    CFBridgingRelease(ref);
    while (start < length)
    {
        CTTypesetterRef typesetter = CTFramesetterGetTypesetter(_frameSetter);
        CFIndex count = CTTypesetterSuggestLineBreak(typesetter, start, boundsWidth);
        [_lines addObject:[NSValue valueWithRange:NSMakeRange(start, count)]];
        start += count;
    }
}

- (void)calcLineHeight
{
    CGFloat asscent, descent, leading;
    if ([_lines count] > 0) {
        CTLineRef line = CTLineCreateWithAttributedString(
            (__bridge CFAttributedStringRef)(
                [_arcAttributedString.attributedString attributedSubstringFromRange:
                    [[_lines objectAtIndex:0] rangeValue]]));

        CTLineGetTypographicBounds(line, &asscent, &descent, &leading);
        _lineHeight = asscent + descent + leading;
        _tableView.rowHeight = ceil(_lineHeight);
    }
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
                 @selector(execOnTableView:ofFile:forValues:sharedObject:delegate:)])
            {
                [plugin execOnTableView:_tableView
                                 ofFile:_currentFile
                              forValues:settings
                           sharedObject:_sharedObject
                               delegate:self];
            }
        }
    }
}

#pragma mark - Tool Bar Methods

- (void)setUpDefaultToolBar {
    _toolbarTitle = [[UIBarButtonItem alloc] initWithTitle:[_currentFile name]
                                                     style:UIBarButtonItemStylePlain
                                                    target:nil
                                                    action:nil];
    _searchButtonIcon = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                      target:self
                                                                                      action:@selector(showSearchToolBar)];
    [_toolbar setItems:[NSArray arrayWithObjects:
                        [Utils flexibleSpace],
                        _toolbarTitle,
                        [Utils flexibleSpace],
                        _searchButtonIcon,
                        nil]];
}

- (void)showSearchToolBar {
    // Replace current toolbar with tool bar with search bar
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(_toolbar.frame.size.width - 250, 0, 200, SIZE_TOOLBAR_HEIGHT)];
    _searchBar.delegate = (id<UISearchBarDelegate>)self;
    
    UIBarButtonItem *searchBarItem = [[UIBarButtonItem alloc] initWithCustomView:_searchBar];
    UIBarButtonItem *doneBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                 target:self
                                                                                 action:@selector(hideSearchToolBar)];
    [_toolbar setItems:[NSArray arrayWithObjects:_toolbarTitle, [Utils flexibleSpace], searchBarItem, doneBarItem, nil] animated:YES];
    
    // Initialize results tableview controller
    _resultsViewController = [[ResultsTableViewController alloc] init];
    _resultsPopoverController = [[UIPopoverController alloc] initWithContentViewController:_resultsViewController];
    _resultsPopoverController.passthroughViews = [NSArray arrayWithObject:_searchBar];
}

- (void)hideSearchToolBar {
    if (UIDeviceOrientationIsLandscape(self.interfaceOrientation))
    {
        [self setUpDefaultToolBar];
    }
    else {
        [self showShowMasterViewButton:_portraitButton];
    }
}

// TODO: Remove once confirmed - search bar on top of code
- (void)addSearchBarToTableViewTop
{
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, SIZE_TOOLBAR_HEIGHT)];
    _tableView.tableHeaderView = _searchBar;
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchBar.delegate = (id<UISearchBarDelegate>)self;
    
    // Hides search bar upon load
    _tableView.contentOffset = CGPointMake(0, SIZE_TOOLBAR_HEIGHT);
}

#pragma mark - Code View Delegate

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
{
    // Temporary solution to resolve asyn mutation of background color
    if ([file isEqual:_currentFile]) {
        _arcAttributedString = arcAttributedString;
        [_tableView reloadData];
    }
}

#pragma mark - Detail View Controller Delegate

- (void)showShowMasterViewButton:(UIBarButtonItem *)button
{
    // Customise the button.
    UIImage *icon = [Utils scale:[UIImage imageNamed:@"Reading Panel.png"]
                          toSize:CGSizeMake(SIZE_TOOLBAR_ICON_WIDTH, SIZE_TOOLBAR_ICON_WIDTH)];
    [button setImage:icon];
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
    cell.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    NSUInteger lineNumber = indexPath.row;
    NSAttributedString *attributedString = [_arcAttributedString.attributedString attributedSubstringFromRange:
                                            [[_lines objectAtIndex:lineNumber] rangeValue]];
    
    CTLineRef lineRef = CTLineCreateWithAttributedString(
                                                         (__bridge CFAttributedStringRef)(attributedString));
    
    cell.line = lineRef;
    cell.string = attributedString.string;
    
    // Additional code
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]
                                                      initWithTarget:self
                                                      action:@selector(getTextLocation:)];
    [cell addGestureRecognizer:longPressGesture];
    
    [cell setNeedsDisplay];
    return cell;
}

- (void)getTextLocation:(UILongPressGestureRecognizer*)longPressGesture {
    CodeLineCell *cell = (CodeLineCell*)[longPressGesture view];
    CGPoint pointOfTouch = [longPressGesture locationInView:cell];
    NSLog(@"point: %f, %f", pointOfTouch.x, pointOfTouch.y);
    
    CTLineRef line = cell.line;
    NSString *cellString = cell.string;
    CFIndex index = CTLineGetStringIndexForPosition(line, pointOfTouch);
    int adjustedIndex = index - 2;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];
}

#pragma mark - Search Bar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar {
    NSString *searchString = [searchBar text];
    NSArray *searchResultRanges = [FullTextSearch searchForText:searchString
                                                         inFile:_currentFile];
    // TODO: Check if searchResultRanges is nil before using the data
    
    // Hide keyboard after search button clicked
    [searchBar resignFirstResponder];
    
    // Show results
    _resultsViewController.resultsArray = searchResultRanges;
    [_resultsViewController.tableView reloadData];
    [_resultsPopoverController presentPopoverFromRect:[_searchBar bounds]
                                              inView:_searchBar
                            permittedArrowDirections:UIPopoverArrowDirectionAny
                                            animated:YES];
}

@end
