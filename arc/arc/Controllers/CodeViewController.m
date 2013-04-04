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
#import "ArcAttributedString.h"

// Middleware
#import "BasicStyles.h"
#import "SyntaxHighlight.h"

@interface CodeViewController ()
@property id<File> currentFile;
@property (nonatomic, strong) UITableView *tableView;
@property ArcAttributedString *arcAttributedString;
@property CTFramesetterRef frameSetter;
@property CGFloat lineHeight;
@property NSMutableArray *lines;
@property NSMutableArray *lineRefs;
- (void)loadFile;
- (void)clearPreviousLayoutInformation;
- (void)clearMemoisedInformation;
- (void)generateLines;
- (void)calcLineHeight;
@end

@implementation CodeViewController
@synthesize delegate = _delegate;
@synthesize toolbar = _toolbar;

- (id)init
{
    self = [super init];
    if (self) {
        _lines = [NSMutableArray array];
        _lineRefs = [NSMutableArray array];
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
    [self.view addSubview:_toolbar];
    
    // Set Up TableView
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                              style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleWidth;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.autoresizesSubviews = YES;
    
    // Set TableView's Delegate and DataSource
    _tableView.dataSource = self;
    _tableView.frame = CGRectMake(0, SIZE_TOOLBAR_HEIGHT,
                                  self.view.bounds.size.width,
                                  self.view.bounds.size.height - SIZE_TOOLBAR_HEIGHT);
    [self.view addSubview:_tableView];
}

- (void)showLeftBar:(id)sender
{
    
}

- (void)hideLeftBar:(id)sender
{

}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //Causes memory bug on iOS6 simulator. 
    //[self refreshSubViewSizes];
}

- (void)showFile:(id<File>)file
{
    if ([file isEqual:_currentFile]) {
        [self clearMemoisedInformation];
        [_tableView reloadData];
        return;
    }
    
    // Update Current file
    _currentFile = file;
    
    [self loadFile];

    // Middleware to Style Attributed String
    [BasicStyles arcAttributedString:_arcAttributedString
                              OfFile:_currentFile
                            delegate:self];
    [SyntaxHighlight arcAttributedString:_arcAttributedString
                                  OfFile:_currentFile
                                delegate:self];

    // Render Code to screen
    [self generateLines];
    [_tableView reloadData];
}

- (void)clearMemoisedInformation
{
    _lineRefs = [NSMutableArray array];
}

- (void)clearPreviousLayoutInformation
{
    if (_frameSetter != NULL) {
        CFRelease(_frameSetter);
        _frameSetter = NULL;
    }

    _lines = [NSMutableArray array];
    [self clearMemoisedInformation];
}

- (void)generateLines
{
    [self clearPreviousLayoutInformation];
    _lines = [NSMutableArray array];
    
    CFAttributedStringRef ref = (CFAttributedStringRef)CFBridgingRetain(_arcAttributedString.attributedString);
    _frameSetter = CTFramesetterCreateWithAttributedString(ref);
    
    // Work out the geometry
    CGFloat boundsWidth = _tableView.bounds.size.width - 20*2 - 45;
    
    // Calculate the lines
    CFIndex start = 0;
    NSUInteger length = CFAttributedStringGetLength(ref);
    while (start < length)
    {
        CTTypesetterRef typesetter = CTFramesetterGetTypesetter(_frameSetter);
        CFIndex count = CTTypesetterSuggestLineBreak(typesetter, start, boundsWidth);
        [_lines addObject:[NSValue valueWithRange:NSMakeRange(start, count)]];
        start += count;
    }
    
    [self calcLineHeight];
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

- (void)loadFile
{
    _arcAttributedString = [[ArcAttributedString alloc]
                            initWithString:(NSString *)[_currentFile contents]];
}

- (void)mergeAndRenderWith:(ArcAttributedString *)arcAttributedString
                   forFile:(id<File>)file
{
    if ([file isEqual:_currentFile]) {
        _arcAttributedString = arcAttributedString;
        [self clearMemoisedInformation];
        [_tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_lines count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString *cellIdentifier = @"CodeLineCell";
    CodeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[CodeLineCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:cellIdentifier];
    }
    cell.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    NSUInteger lineNumber = indexPath.row;

    CTLineRef lineRef = (lineNumber < [_lineRefs count]) ?
        (__bridge CTLineRef)[_lineRefs objectAtIndex:lineNumber] : nil;
    
    if (lineRef == nil) {
        lineRef = CTLineCreateWithAttributedString(
            (__bridge CFAttributedStringRef)(
                [_arcAttributedString.attributedString attributedSubstringFromRange:
                [[_lines objectAtIndex:lineNumber] rangeValue]]));
        
        // Memoise.
        if (_lineRefs) {
           [_lineRefs insertObject:(__bridge id)(lineRef) atIndex:lineNumber]; 
        }
    }
    
    cell.line = lineRef;
    [cell setNeedsDisplay];
    return cell;
}

@end
